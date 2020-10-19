using System;
using UnityEngine;

public class Projectile : MonoBehaviour, IGravitable<Vector2>
{
    [SerializeField] private bool affectedByGravityZones = false;
    
    private new Rigidbody2D rigidbody2D = default;
    
    private void Awake()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (!collision.collider.CompareTag("Player"))
        {
            Destroy(gameObject);
        }
    }

    
    public void AddForce(Vector2 direction, float magnitude)
    {
        if (!affectedByGravityZones) return;
        rigidbody2D.AddForce(direction * magnitude);
    }
}
