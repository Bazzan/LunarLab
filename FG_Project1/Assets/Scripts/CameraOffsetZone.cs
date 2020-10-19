using UnityEngine;

public class CameraOffsetZone : MonoBehaviour
{
    private Camera camera;
    
    [Header("Camera Offset")]
    [SerializeField] private Vector3 offset = default;
    
    [Header("Gizmos")]
    [SerializeField] private bool gizmosEnabled = default;
    [SerializeField] private Color gizmoColor = default;
    
    private void Awake()
    {
        camera = Camera.main;
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        camera.GetComponent<CameraController>().roomOffset = offset;
    }
    
    private void OnTriggerExit2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        camera.GetComponent<CameraController>().roomOffset = Vector3.zero;
    }

    private void OnDrawGizmos()
    {
        if (!gizmosEnabled) return;
        Gizmos.color = gizmoColor;
        BoxCollider2D boxCollider2D = GetComponent<BoxCollider2D>();
        Gizmos.DrawCube(transform.position + (Vector3)boxCollider2D.offset, boxCollider2D.size);
    }
}
