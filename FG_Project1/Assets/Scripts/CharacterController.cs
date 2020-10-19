using UnityEngine;

public class CharacterController : MonoBehaviour, IGravitable<Vector2>
{
    private UnityEngine.InputSystem.PlayerInput inputModule;
    private PlayerInput playerInput;
    private new Rigidbody2D rigidbody2D;

    [Header("Player ship")]
    [Tooltip("Ship thruster force")]
    [SerializeField] private float thrusterForce = 4f;
    [Tooltip("Ship rotation speed")]
    [SerializeField] private float rotationSpeed = 1f;
    [Range(0f, 1f)]
    [Tooltip("The drag applied to the ship, dependent on direction")]
    [SerializeField] private float dragMultiplier = 0.1f;
    [Tooltip("Maximum possible speed to achieve, independent of forces applied")]
    [SerializeField] private float maxSpeed = 10f;

    [Header("Close to wall thrust mechanic")]
    [Tooltip("Distance at which wall thrust start giving extra thrust power")]
    [SerializeField] private float raycastDistance = 5f;
    [Tooltip("Close to wall thrust layer mask")]
    [SerializeField] private LayerMask wallLayerMask = default;
    [Tooltip("Extra force when back is close to wall")]
    [SerializeField] private float wallThrustMultiplier = 10f;

    [SerializeField] private AnimationCurve curve = default;

    [HideInInspector] public bool playerControlsNotActive = true;
    public bool thrustingEnabled = true;
    public bool rotationEnabled = true;
    private bool dragEnabled = true;

    private float thrusterMultiplier = 1f;
    //todo calculate circleRadius by collider radius
    private float circleRadius = 1f;

    private void Awake()
    {
        inputModule = GetComponent<UnityEngine.InputSystem.PlayerInput>();
        playerInput = GetComponent<PlayerInput>();
        rigidbody2D = GetComponent<Rigidbody2D>();
        playerControlsNotActive = true;
        rigidbody2D.isKinematic = true;
    }

    private void FixedUpdate()
    {
        StaticUntilInput();
        
        WallChecker();
        Drag();
        Move();
        Rotate();
    }
    
    private void StaticUntilInput()
    {
        if (playerControlsNotActive)
            if (playerInput.Thrust > 0.1f || playerInput.MoveInput != 0)
                rigidbody2D.isKinematic = false;
    }
    
    private void Move()
    {
        if (!thrustingEnabled) return;
        AddForce(transform.up, thrusterMultiplier * thrusterForce * playerInput.Thrust);
    }

    private void WallChecker()
    {
        RaycastHit2D hit2D = Physics2D.CircleCast(transform.position, circleRadius, rigidbody2D.velocity.normalized, raycastDistance, wallLayerMask);
        float distance = Vector2.Distance(transform.position, hit2D.point);
        float dot = Vector2.Dot(hit2D.normal, transform.up);
        float velocityDot = Vector2.Dot(rigidbody2D.velocity.normalized, hit2D.normal);
        thrusterMultiplier = 1f;
        if (dot >= 0f && velocityDot <= 0f)
            thrusterMultiplier = 1f + dot * wallThrustMultiplier * curve.Evaluate(1f - (distance / raycastDistance)) * rigidbody2D.velocity.magnitude; // Close 0 - Far 1
    }

    private void Drag()
    {
        if (!dragEnabled) return;
        Vector2 dir = (Vector2)transform.up - rigidbody2D.velocity;
        AddForce(transform.up * dir.normalized, dragMultiplier * rigidbody2D.velocity.magnitude);
    }

    private void Rotate()
    {
        if (!rotationEnabled) return;
        rigidbody2D.AddTorque(rotationSpeed * playerInput.MoveInput);
    }

    private void RotateAlt()
    {
        if (!rotationEnabled) return;
        if (playerInput.MoveAltInput.magnitude == 0) return;

        if (Vector2.Dot(transform.right, playerInput.MoveAltInput) < 0f)
            rigidbody2D.AddTorque(rotationSpeed);
        else
            rigidbody2D.AddTorque(-rotationSpeed);
    }

    public void AddForce(Vector2 direction, float magnitude)
    {
        rigidbody2D.AddForce(direction * magnitude);
        rigidbody2D.velocity = Vector2.ClampMagnitude(rigidbody2D.velocity, maxSpeed);
    }

    public void LossOfControl(bool thrust, bool rotate, bool drag)
    {
        thrustingEnabled = thrust;
        rotationEnabled = rotate;
        dragEnabled = drag;
    }
    
#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
        //Gizmos.DrawLine(hit2D.point,  hit2D.point + hit2D.normal * 10f);
        RaycastHit2D hit2D = Physics2D.CircleCast(transform.position, circleRadius, rigidbody2D.velocity.normalized, raycastDistance, wallLayerMask);

        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(hit2D.point, hit2D.point + hit2D.normal);

        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(transform.position, (Vector2)transform.position + rigidbody2D.velocity);
    }
#endif
}
