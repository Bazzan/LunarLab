using System;
using UnityEngine;

public class ThrustMeterZone : MonoBehaviour
{
    [SerializeField] private Transform moveableObject = default;
    [SerializeField] private Transform startPoint = default;
    [SerializeField] private Transform endPoint = default;
    [SerializeField] private float meterRate = default;
    [SerializeField] private float resetRate = default;
    
    private float thrustMeter = 0f;
    
    [SerializeField] private bool sizeGizmoEnabled = true;
    [SerializeField] private Color sizeGizmoColor = default;
    
    private void Start()
    {
        moveableObject.transform.position = startPoint.position;
    }
    
    private void Update()
    {
        if (thrustMeter <= 0f) return;
        thrustMeter -= Time.deltaTime * resetRate;
        MoveObject();
    }
    
    private void MoveObject()
    {
        moveableObject.transform.position = Vector3.Lerp(startPoint.position, endPoint.position, thrustMeter);
    }
    
    public void AddToMeter()
    {
        if (thrustMeter >= 1f) return;
        thrustMeter += Time.deltaTime * meterRate;
    }
    
    private void OnDrawGizmos()
    {
        if (sizeGizmoEnabled)
        {
            Gizmos.color = sizeGizmoColor;
            Gizmos.DrawCube(transform.position, GetComponent<BoxCollider2D>().size);
        }
        
        Gizmos.DrawLine(transform.position, startPoint.position);
        Gizmos.DrawLine(transform.position, endPoint.position);
        Gizmos.DrawLine(startPoint.position, endPoint.position);
    }
}
