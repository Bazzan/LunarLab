using UnityEngine;
[RequireComponent(typeof( BoxCollider2D))]
public class CheckPoint : MonoBehaviour
{

    [SerializeField]private ParticleSystem[] particleSystems;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            CheckPointManager.Instance.lastCheckPoint = transform.position;
            GetComponent<Collider2D>().enabled = false;

            foreach (ParticleSystem particleSystem in particleSystems)
            {
                particleSystem.Play();
            }
        }

    }

    private void OnDrawGizmos()
    {
        Gizmos.color = new Color(0, 1, 0, .5f);
        Gizmos.DrawCube(transform.position, new Vector3(GetComponent<BoxCollider2D>().size.x * transform.localScale.x, GetComponent<BoxCollider2D>().size.y * transform.localScale.y, 1));
    }
}
