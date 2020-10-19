using System;
using UnityEngine;
using UnityEngine.Events;

public class Heatpad : MonoBehaviour
{
    [SerializeField] private Color coldColor = default;
    [SerializeField] private Color warmColor = default;
    [SerializeField] private float coolRate = default;
    [SerializeField] private float heatRate = default;
    
    [SerializeField] private bool spin = default;
    [Tooltip("The fastest speed it can spin")]
    [SerializeField] private float spinSpeed = default;
    private Material material;
    private float heat = 0f;
    
    [SerializeField] private GameObject rotatableObject = default;
    [SerializeField] private Renderer rendererObject = default;
    
    [SerializeField] private UnityEvent heatedEvent = new UnityEvent();
    [SerializeField] private UnityEvent cooledEvent = new UnityEvent();
    
    private void Awake()
    {
        if (spin) return;
        material = rendererObject.material;
    }
    
    private void Update()
    {
        heat = heat > 0f ? heat - coolRate * Time.deltaTime : 0f;
        if (spin)
            rotatableObject.transform.Rotate(transform.up, heat);
        else
            material.color = Color.Lerp(coldColor, warmColor, heat);
        if (heat <= 0f)
            cooledEvent.Invoke();
    }
    
    public void AddHeat(float value)
    {
        if (heat < 1f)
            heat += value * heatRate;
        if (heat >= 1f)
        {
            heatedEvent.Invoke();
            heat = 1f;
        }
    }
    
    public void Break()
    {
        Destroy(gameObject);
    }
    
    public void OpenDoor()
    {
        // open a door or something
    }
}
