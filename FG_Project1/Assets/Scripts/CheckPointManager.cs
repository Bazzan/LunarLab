using UnityEngine;

public class CheckPointManager : MonoBehaviour
{
    public Transform PlayerTransform;
    public static CheckPointManager Instance;

    public Vector2 lastCheckPoint = default;
    public Transform[] checkpointTransforms;
    private Rigidbody2D playerRigidbody2D;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }

        lastCheckPoint = PlayerTransform.position;
        playerRigidbody2D = PlayerTransform.GetComponent<Rigidbody2D>();
    }


    public void RespawnAtLastCheckPoint()
    {
        playerRigidbody2D.velocity = Vector2.zero;
        playerRigidbody2D.angularVelocity = 0f;
        PlayerTransform.position = lastCheckPoint;
        PlayerTransform.rotation = Quaternion.Euler(0, 0, 0);
    }

    public void RespawnAtCheckPoint(int index)
    {
        playerRigidbody2D.velocity = Vector2.zero;
        playerRigidbody2D.angularVelocity = 0f;
        PlayerTransform.position = checkpointTransforms[index].position;
        PlayerTransform.rotation = Quaternion.Euler(0, 0, 0);
    }



}
