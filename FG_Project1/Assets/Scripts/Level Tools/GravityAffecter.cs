using UnityEngine;

public class GravityAffecter : MonoBehaviour
{
    public enum Force
    {
        Circle,
        Square
    }

    public enum AffectedLayers
    {
        Player,
        GravityObject
    }

    [Header("Properties")]
    public Force forceType;
    public AffectedLayers layers;
    public int layerMaskValue;
    public LayerMask detectionLayers;

    public float force = 50f;
    public float minForce = 0, maxForce = 100;
    public bool negativeForce = false;

    [Header("Sphere")]
    public float radius = 4f;
    public float transitionRadius = 1f;
    public float minRadius = 1, maxRadius = 5;

    [Header("Customizeable")]
    public Color gizmoColors = default;
    public bool enableColor = true;
    public bool drawGizmos = true;

    [Header("Cube Stuff")]
    public Vector2 centerSize = new Vector2(3f, 3f);
    public float forceDirection = 0f;
    public Vector2 arrowDirection = default;
    public float minSize = 0, maxSize = 10;

    private Collider2D playerCollider;
    Transform playerTransform;
    GameObject playerGo;

    private void Start()
    {
        gameObject.layer = 11;

        playerGo = GameObject.Find("Player");
        playerTransform = playerGo.transform;
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        if (drawGizmos)
        {
            switch (forceType)
            {
                case Force.Circle:
                    {
                        Gizmos.color = new Color(gizmoColors.b, gizmoColors.g, gizmoColors.b, 1);
                        Gizmos.DrawWireSphere(transform.position, radius * (transitionRadius + 1));
                        break;
                    }

                case Force.Square:
                    {
                        Gizmos.color = new Color(gizmoColors.b, gizmoColors.g, gizmoColors.b, 0.1f);
                        Gizmos.DrawCube(transform.position, new Vector3(centerSize.x, centerSize.y, 0f));
                        Gizmos.color = new Color(gizmoColors.b, gizmoColors.g, gizmoColors.b, 1f);
                        Gizmos.DrawWireCube(transform.position, new Vector3(centerSize.x, centerSize.y, 0f));
                        break;
                    }
            }
        }
    }
#endif

    private void FixedUpdate()
    {

        switch (forceType)
        {
            case Force.Circle:
                {
                    float totalRadius = radius * (transitionRadius + 1);          //Calculates total distance

                    playerCollider = Physics2D.OverlapCircle(transform.position, totalRadius, detectionLayers); // 
                    if (playerCollider == null) return;

                    Vector2 midpointDirection = playerCollider.transform.position - transform.position;                         //Finds middlepoint of the cirle
                    float objectDistanceFromCenter = Vector2.Distance(transform.position, playerCollider.transform.position);   //Distance between object from the center of the circle

                    if (objectDistanceFromCenter <= totalRadius)    //When the object is within the area it accelerates untill it reaches inner center point
                    {
                        float distancePercentage = Mathf.InverseLerp(totalRadius, radius, objectDistanceFromCenter);
                        float forcePower = negativeForce ? force * -1 : force;  //Reverses force if true

                        playerCollider.GetComponent<IGravitable<Vector2>>().AddForce(midpointDirection.normalized, (forcePower * distancePercentage));
                    }

                    break;
                }

            case Force.Square:
                {

                    playerCollider = Physics2D.OverlapBox((Vector2)transform.position, (Vector2)centerSize, 0f, detectionLayers);
                    
                    if (playerCollider == null) return;

                    float forcePower = negativeForce ? force * -1 : force;  //Reverses force if true
                    float changeDirection = forceDirection > 0.1 ? 90 : -90;
                    float yValue = Mathf.Lerp(1, 0, forceDirection / changeDirection);

                    playerCollider.GetComponent<IGravitable<Vector2>>()
                        .AddForce(new Vector2(forceDirection / 90, yValue), forcePower);

                    break;
                }
        }
    }
}
