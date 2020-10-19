using System;
using UnityEngine;

public class ProjectileShooter : MonoBehaviour
{
    [SerializeField] private float startDelay;
    [SerializeField] private float fireRate;
    [SerializeField] private float force;
    [SerializeField] private GameObject projectile;
    [SerializeField] private Transform firePoint;

    private float timeLastFired;

    private void Awake()
    {
        timeLastFired = -startDelay;
    }
    float timer = 0;
    private void Update()
    {
        timer += Time.deltaTime;
        if (timer < timeLastFired + 1f / fireRate) return;
        timeLastFired = timer;
        Fire();
    }

    private void Fire()
    {
        GameObject go = Instantiate(projectile, firePoint.position, Quaternion.identity);
        go.GetComponent<Rigidbody2D>().AddForce(firePoint.up * force, ForceMode2D.Impulse);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(transform.position, firePoint.position);

        // Draw Arrow representing projectile direction
        Gizmos.color = Color.cyan;
        Gizmos.matrix = Matrix4x4.TRS(firePoint.position, firePoint.rotation, new Vector3(1, force * 0.1f, 1));
        Gizmos.DrawLine(new Vector2(-0.2f, 0f), new Vector2(-0.2f, 2f));
        Gizmos.DrawLine(new Vector2(0.2f, 0f), new Vector2(0.2f, 2f));

        Gizmos.DrawLine(new Vector2(-0.2f, 2f), new Vector2(-0.5f, 2f));
        Gizmos.DrawLine(new Vector2(0.2f, 2f), new Vector2(0.5f, 2f));

        Gizmos.DrawLine(new Vector2(-0.5f, 2f), new Vector2(0f, 2.5f));
        Gizmos.DrawLine(new Vector2(0.5f, 2f), new Vector2(0, 2.5f));
    }
}
