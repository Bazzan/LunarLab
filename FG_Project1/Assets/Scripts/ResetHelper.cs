using UnityEngine;

public class ResetHelper : MonoBehaviour
{
    [SerializeField] private Transform[] checkpoints = default;
    private Rigidbody2D player = default;

    private void Awake()
    {
        player = GameObject.FindGameObjectWithTag("Player").GetComponent<Rigidbody2D>();
    }

    public void TeleportToCheckpoint(int index)
    {
        player.position = checkpoints[index].position;
        Debug.Log("Teleporting to checkpoint");
    }
}