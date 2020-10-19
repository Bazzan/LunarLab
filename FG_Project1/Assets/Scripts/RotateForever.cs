using UnityEngine;

public class RotateForever : MonoBehaviour
{
    [SerializeField] private float rotationSpeed = 0.001f;

    private Rigidbody2D rigidbody2D;
    
    private void Awake() => rigidbody2D = GetComponentInParent<Rigidbody2D>();

    private void FixedUpdate() => transform.Rotate(Vector3.up, rigidbody2D.angularVelocity * rotationSpeed);
}
