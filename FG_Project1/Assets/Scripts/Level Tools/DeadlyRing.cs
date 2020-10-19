using System.Collections.Generic;
using UnityEngine;

public class DeadlyRing : MonoBehaviour
{
    [Header("General Stuff")]
    //Things only code should see
    [HideInInspector] public GameObject circleRef;
    [HideInInspector] public float circleRadius;
    float progression;

    // Trigger/Detection
    [Header("Don't touch!")]
    public bool spawnDangerZone = false;
    Collider2D detectedObjects;
    //Transform player;
    LayerMask layerMask = 1024;

    //Checkpoints
    [Header("Checkpoits")]
    public List<CheckPoints> point = new List<CheckPoints>(1);
    public bool displayGizmos = true;
    public bool displayHandles = true;
    public bool startEvent;
    int checkpoint;
    float distanceBetweenPoints;
    float distanceBetweenPlayerAndFinnish;

    #region ADD / REMOVE POINTS
    public void AddPoints()
    {
        if (transform.childCount <= 0)  //If there are no points
        {
            point.Add(new CheckPoints());

            //Spawn 2 new children
            for (int i = 0; i < 2; i++)     
            {
                GameObject child = new GameObject();
                child.transform.parent = transform;
                child.name = $"Point {i + 1}";
            }

            if (transform.childCount == 2)
            {
                point[0].startPointTransform = transform.GetChild(0);
                point[0].endPointTransform = transform.GetChild(1);
            }
        }

        //If the first line already exist
        else if (transform.childCount >= 2)
        {
            point.Add(new CheckPoints());
            GameObject child = new GameObject();
            child.transform.parent = transform;
            child.name = $"Point {transform.childCount}";
            for (int i = 1; i < point.Count; i++)
            {
                point[i].startPointTransform = point[i-1].endPointTransform;
                point[i].endPointTransform = transform.GetChild(i + 1);
            }
        }
    }

    //Remove the last child (last point)
    public void RemovePoints()
    {
        DestroyImmediate(transform.GetChild(transform.childCount - 1).gameObject);
        checkpoint = 0;
        point.RemoveAt(transform.childCount - 1);
    }

    #endregion

    #region Gizmos
#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        if (transform.childCount > 0 && displayGizmos)
        {
            for (int i = 0; i < point.Count; i++)
            {
                Gizmos.color = new Color
                        (point[i].lineColor.r, point[i].lineColor.g, point[i].lineColor.b, 1f);
                Gizmos.DrawWireSphere(point[i].endPointTransform.transform.position,
                        point[i].endSize);
                Gizmos.color = Color.white;
                Gizmos.DrawLine(point[i].startPointTransform.position, point[i].endPointTransform.position);
            }
        }
    }
#endif
    #endregion

    private void Update()
    {
        //If gamobject has points
        if (transform.childCount >= 1)
        {
            //If player collides with the first point or trigger through the inspector
            detectedObjects = Physics2D.OverlapCircle(transform.GetChild(0).transform.position, 1f, layerMask);
            
            if(detectedObjects != null || spawnDangerZone)
            {
                startEvent = true;
                spawnDangerZone = false;
                circleRef = new GameObject();
                circleRef.name = "Danger Zone";
                //player = detectedObjects.transform;
            }

            //When the circle is triggerd
            if (startEvent)
            {
                distanceBetweenPoints = Vector2.Distance(point[checkpoint].startPointTransform.position, point[checkpoint].endPointTransform.position);     //Calculates the distance between start point and end point
                distanceBetweenPlayerAndFinnish = Vector2.Distance(circleRef.transform.position, point[checkpoint].endPointTransform.position);             //Calculates the distance between player and end point

                progression += point[checkpoint].speed * Time.deltaTime;    //Calculate speed
                circleRef.transform.position = Vector2.MoveTowards(point[checkpoint].startPointTransform.position, point[checkpoint].endPointTransform.position, progression);  //Changes cirlcle's position
                circleRadius = Mathf.Lerp(point[checkpoint].endSize, point[checkpoint].startSize, distanceBetweenPlayerAndFinnish / distanceBetweenPoints);                     //Changes cirlcle's radius

                if (Vector2.Distance(circleRef.transform.position, point[checkpoint].endPointTransform.position) == 0)
                {
                    progression = 0;
                    checkpoint++;
                }

                if (checkpoint == point.Count /*|| Vector2.Distance(player.position, circleRef.transform.position) > circleRadius*/)
                {
                    //If you want to add an effect like a reward or somthing, just instanciate it here!
                    startEvent = false;
                    Destroy(circleRef.gameObject);
                }
            }
        }
    }
}

[System.Serializable]
public class CheckPoints
{
    //Points & Colors
    public Transform startPointTransform = default;
    public Transform endPointTransform = default;
    public Color lineColor;

    //Sizes & Speeds
    public float min = 1f, max = 5f;
    public float startSize = 1f, endSize = 1f;
    public float speed;
}
