using UnityEngine;

public class Thruster : MonoBehaviour
{
    private PlayerInput playerInput = default;
    [SerializeField] private new PolygonCollider2D collider2D = default;
    
    [Tooltip("Distance at which wall thrust start giving extra thrust power")]
    [SerializeField] private float circleCastDistance = 0.5f;
    [Tooltip("Distance at which wall thrust start giving extra thrust power")]
    [SerializeField] private float circleCastRadius = 1f;
    [Tooltip("Close to wall thrust layer mask")]
    [SerializeField] private LayerMask wallLayerMask = default;
    
    private void Awake()
    {
        playerInput = GetComponentInParent<PlayerInput>();
        collider2D = GetComponent<PolygonCollider2D>();
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (playerInput.Thrust <= 0f) return;
        
        if (other.CompareTag("ThrustMeter"))
            other.GetComponent<ThrustMeterZone>().AddToMeter();
        
        if (!other.CompareTag("Heatpad")) return;
        Heat();
    }
    
    private void Heat()
    {
        RaycastHit2D[] hit2D = Physics2D.CircleCastAll(transform.position, circleCastRadius, -transform.up, circleCastDistance, wallLayerMask);
        for (int i = 0; i < hit2D.Length; i++)
        {
            if (hit2D[i].collider != null)
                hit2D[i].collider.gameObject.GetComponent<Heatpad>().AddHeat(1f - hit2D[i].distance / circleCastDistance);
        }
    }
    
    private void OnDrawGizmos()
    {
        collider2D = GetComponent<PolygonCollider2D>();
        
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, 0.1f);
        Gizmos.DrawLine(transform.position, transform.position - (transform.up * circleCastDistance));
        
        Gizmos.matrix = Matrix4x4.TRS(transform.position, transform.rotation, transform.localScale);
        Gizmos.color = Color.green;
        for (int i = 0; i < collider2D.points.Length; i++)
        {
            Gizmos.DrawLine(collider2D.points[i], 
                collider2D.points[i < collider2D.points.Length - 1? i + 1 : 0]);
        }
    }
}
