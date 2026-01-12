using UnityEngine;
#if ENABLE_INPUT_SYSTEM
using UnityEngine.InputSystem;
#endif

public class AccelerometerReader : MonoBehaviour
{
    [Header("Serial Source")]
    public ArduinoCommunicator arduinoCommunicator; // drag it in if not found automatically

    [Header("Arduino IDs (match what you send)")]
    public int axId = 1;
    public int ayId = 2;
    public int azId = 3;

    [Header("Plane to rotate (leave null to rotate this GameObject)")]
    public Transform target;

    [Header("Rotation Tuning")]
    public float maxPitchDegrees = 30f;   // nose up/down range (X axis)
    public float maxRollDegrees  = 45f;   // bank left/right range (Z axis)
    public float smoothTime = 0.15f;      // higher = smoother/slower response
    public float rotationLerpSpeed = 10f; // higher = snappier rotation

    [Header("Deadzone (ignore tiny tilt/noise)")]
    [Range(0f, 0.3f)] public float deadzone = 0.03f;

    [Header("Calibration")]
    public bool calibrateWithKey = true;
    public KeyCode calibrateKey = KeyCode.C;

    [Header("Debug (read-only in Inspector)")]
    public float ax; // visible in Inspector
    public float ay;
    public float az;
    public float pitchDeg;
    public float rollDeg;

    // Internal smoothing state
    private Vector3 _accelSmoothed;
    private Vector3 _accelVel;
    private Quaternion _neutralRotation = Quaternion.identity;
    private Vector3 _neutralGravity = Vector3.up;
    private bool _hasNeutralGravity = false;

    void Start()
    {
        if (target == null) target = transform;

        // Try to find the communicator automatically if not set
        if (arduinoCommunicator == null)
        {
            arduinoCommunicator = GameObject.FindFirstObjectByType<ArduinoCommunicator>();
        }

        if (arduinoCommunicator == null)
        {
            Debug.LogError("❌ ArduinoCommunicator not found in scene!");
        }

        _neutralRotation = target.rotation;
    }

    void Update()
    {
        if (arduinoCommunicator == null) return;

        // Optional: recalibrate neutral orientation (handy if you want “current pose” = centered)
        if (calibrateWithKey && WasCalibratePressed())
        {
            _neutralRotation = target.rotation;

            // Set “level” reference based on current gravity direction
            if (_accelSmoothed.sqrMagnitude > 0.0001f)
            {
                _neutralGravity = _accelSmoothed.normalized;
                _hasNeutralGravity = true;
            }
        }

        // Read ax/ay/az from ArduinoCommunicator
        ax = ReadValueOrKeep(axId, ax);
        ay = ReadValueOrKeep(ayId, ay);
        az = ReadValueOrKeep(azId, az);

        // Smooth accelerometer vector to reduce jitter
        Vector3 accel = new Vector3(ax, ay, az);
        _accelSmoothed = Vector3.SmoothDamp(_accelSmoothed, accel, ref _accelVel, smoothTime);

        // If accel is near zero (bad packets / not connected), do nothing
        if (_accelSmoothed.sqrMagnitude < 0.0001f) return;

        // Normalize to get “gravity direction” (tilt)
        // NOTE: Depending on your sensor mounting, you might need to flip/swaps axes.
        Vector3 g = _accelSmoothed.normalized;

        // First valid reading becomes the default “neutral” reference
        if (!_hasNeutralGravity)
        {
            _neutralGravity = g;
            _hasNeutralGravity = true;
        }

        // Map tilt to pitch & roll relative to the calibrated “neutral” gravity direction.
        // We build a local basis (right/forward) around the neutral gravity vector so your
        // sensor mounting doesn’t have to match Unity axes exactly.
        Vector3 up = _neutralGravity;

        // Build a stable 'right' axis from world-up and neutral-up. If they’re nearly parallel,
        // fall back to a fixed axis to avoid numerical issues.
        Vector3 right = Vector3.Cross(Vector3.up, up);
        if (right.sqrMagnitude < 1e-6f) right = Vector3.right;
        right.Normalize();

        // Forward completes the basis (right-handed)
        Vector3 forward = Vector3.Cross(up, right).normalized;

        // Project current gravity onto that basis:
        //  - right component: tilt left/right  -> ROLL (bank) around Z
        //  - forward component: tilt forward/back -> PITCH around X
        float roll01  = Mathf.Clamp(Vector3.Dot(g, right), -1f, 1f);
        float pitch01 = Mathf.Clamp(-Vector3.Dot(g, forward), -1f, 1f); // invert if it feels backwards

        // Deadzone to ignore tiny noise around center
        if (Mathf.Abs(pitch01) < deadzone) pitch01 = 0f;
        if (Mathf.Abs(roll01) < deadzone) roll01 = 0f;

        pitchDeg = pitch01 * maxPitchDegrees;
        rollDeg  = roll01  * maxRollDegrees;

        // Apply rotations on top of the neutral orientation.
        // Order: neutral -> roll around local forward (Z) -> pitch around local right (X).
        // If roll feels inverted, negate rollDeg below.
        Quaternion targetRot =
            _neutralRotation *
            Quaternion.AngleAxis(rollDeg, Vector3.forward) *
            Quaternion.AngleAxis(pitchDeg, Vector3.right);

        target.rotation = Quaternion.Slerp(target.rotation, targetRot, Time.deltaTime * rotationLerpSpeed);
    }

    private float ReadValueOrKeep(int id, float fallback)
    {
        ArduinoValue? v = arduinoCommunicator.GetItemById(id);
      
        if (v != null)
        {
            return v.Value.GetValue();
        }
        return fallback;
    }

    private bool WasCalibratePressed()
    {
#if ENABLE_INPUT_SYSTEM
        // New Input System
        if (Keyboard.current == null) return false;

        // Map the selected KeyCode to a Key (covers the common keys you’ll likely use).
        // If your key isn't covered, switch calibrateKey to something included below.
        return calibrateKey switch
        {
            KeyCode.C => Keyboard.current.cKey.wasPressedThisFrame,
            KeyCode.Space => Keyboard.current.spaceKey.wasPressedThisFrame,
            KeyCode.Return => Keyboard.current.enterKey.wasPressedThisFrame,
            KeyCode.Escape => Keyboard.current.escapeKey.wasPressedThisFrame,
            KeyCode.LeftShift => Keyboard.current.leftShiftKey.wasPressedThisFrame,
            KeyCode.RightShift => Keyboard.current.rightShiftKey.wasPressedThisFrame,
            KeyCode.LeftControl => Keyboard.current.leftCtrlKey.wasPressedThisFrame,
            KeyCode.RightControl => Keyboard.current.rightCtrlKey.wasPressedThisFrame,
            KeyCode.LeftAlt => Keyboard.current.leftAltKey.wasPressedThisFrame,
            KeyCode.RightAlt => Keyboard.current.rightAltKey.wasPressedThisFrame,
            _ => false
        };
#else
        // Old Input Manager
        return Input.GetKeyDown(calibrateKey);
#endif
    }

    void OnGUI()
    {
        GUI.Label(new Rect(10, 10, 420, 22), $"ax:{ax:F3}  ay:{ay:F3}  az:{az:F3}");
        GUI.Label(new Rect(10, 32, 420, 22), $"pitch:{pitchDeg:F1}°  roll:{rollDeg:F1}°  (press '{calibrateKey}' to calibrate)");
    }
}