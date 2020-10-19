using UnityEngine;

public class LostControlZone : MonoBehaviour
{
    [SerializeField] private bool thrustingEnabled = true;
    [SerializeField] private bool rotationEnabled = true;
    [SerializeField] private bool dragEnabled = true;
    
    [SerializeField] private bool sizeGizmoEnabled = true;
    [SerializeField] private Color sizeGizmoColor = default;
    [SerializeField] private bool iconGizmosEnabled = true;
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;
        
        other.GetComponent<CharacterController>().LossOfControl(thrustingEnabled, rotationEnabled, dragEnabled);
    }
    
    private void OnTriggerExit2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;
        
        other.GetComponent<CharacterController>().LossOfControl(true, true, true);
    }
    
    private void OnDrawGizmos()
    {
        if (sizeGizmoEnabled)
        {
            Gizmos.color = sizeGizmoColor;
            Gizmos.DrawCube(transform.position, GetComponent<BoxCollider2D>().size);
        }
        
        if (iconGizmosEnabled)
        {
            if (thrustingEnabled)
                Gizmos.DrawIcon(transform.position + new Vector3(1, 1), "d_TransformTool@2x", true);
            else
                Gizmos.DrawIcon(transform.position + new Vector3(1, 1), "d_winbtn_mac_close_h@2x", true);

            if (rotationEnabled)
                Gizmos.DrawIcon(transform.position + new Vector3(2.5f, 1), "d_RotateTool@2x", true);
            else
                Gizmos.DrawIcon(transform.position + new Vector3(2.5f, 1), "d_winbtn_mac_close_h@2x", true);

            if (dragEnabled)
                Gizmos.DrawIcon(transform.position + new Vector3(4, 1), "DefaultSorting@2x", true);
            else
                Gizmos.DrawIcon(transform.position + new Vector3(4, 1), "d_winbtn_mac_close_h@2x", true);
        }
    }
}