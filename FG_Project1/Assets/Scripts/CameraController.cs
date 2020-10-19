using System;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    private Rigidbody2D playerRigidbody2D;
    
    [Header("Target")]
    [SerializeField] private Transform playerTransform = default;
    
    [Header("LookAhead")]
    [SerializeField] private Vector3 offset = new Vector3();
    [SerializeField] private float damping = 0.1f;
    [SerializeField] private float lookAheadMultiplier = 1f;
    [SerializeField] private float playerUpMultiplier = 1f;
    
    private Vector3 targetPosition = default;
    
    private Camera camera;
    private Vector3 velocity;

    public Vector3 roomOffset = Vector3.zero;
    
    [Header("Trauma")]
    [SerializeField] private float traumaDecay = 0.1f;
    [SerializeField] private float velocityMaxTrauma = 0.2f;
    
    [Header("Translational")]
    [SerializeField] private Vector3 translationalMaxOffset = Vector3.one;
    [SerializeField] private float translationalShake = 0.1f;
    [SerializeField] private float translationalFrequency = 10f;
    
    [Header("Rotational")]
    [SerializeField] private Vector3 rotationalMaxOffset = Vector3.one;
    [SerializeField] private float rotationalShake = 1f;
    [SerializeField] private float rotationalFrequency = 10f;

    private float seed = 0f;
    private float trauma = 0f;

    public void AddTrauma(float value) => Mathf.Clamp01(trauma += value);

    private void Awake()
    {
        playerRigidbody2D = playerTransform.GetComponent<Rigidbody2D>();
        camera = GetComponent<Camera>();
        camera.transform.position = playerTransform.position + offset;
    }

    private void Update()
    {
        if (trauma < 0f) return;
        trauma -= Time.deltaTime * traumaDecay;
    }
    
    private void FixedUpdate()
    {
        if (trauma <= velocityMaxTrauma)
        trauma = (playerRigidbody2D.velocity.magnitude / 18f) * velocityMaxTrauma;
        
        Vector3 tempTarget = LookAhead() + roomOffset + TranslationalShake();
        camera.transform.position = Vector3.SmoothDamp(
            camera.transform.position, tempTarget, ref velocity, damping);
        
        camera.transform.rotation = RotationalShake();
    }
    
    private Vector3 LookAhead()
    {
        Vector3 mixedPosition = playerTransform.up * playerUpMultiplier * playerRigidbody2D.velocity.magnitude +
                                (Vector3) playerRigidbody2D.velocity * lookAheadMultiplier;
        return playerTransform.position + mixedPosition + offset;
    }
    
    private Vector3 TranslationalShake()
    {
        return translationalShake * trauma * trauma * new Vector3(
            Mathf.Clamp(GetPerlinNoise(seed, translationalFrequency), -translationalMaxOffset.x, translationalMaxOffset.x),
            Mathf.Clamp(GetPerlinNoise(seed + 1, translationalFrequency), -translationalMaxOffset.y, translationalMaxOffset.y),
            Mathf.Clamp(GetPerlinNoise(seed + 2, translationalFrequency), -translationalMaxOffset.z, translationalMaxOffset.z));
    }
    
    private Quaternion RotationalShake()
    {
        return Quaternion.Euler(rotationalShake * trauma * trauma * new Vector3(
            Mathf.Clamp(GetPerlinNoise(seed, rotationalFrequency), -rotationalMaxOffset.x, rotationalMaxOffset.x),
            Mathf.Clamp(GetPerlinNoise(seed + 1, rotationalFrequency),-rotationalMaxOffset.y, rotationalMaxOffset.y),
            Mathf.Clamp(GetPerlinNoise(seed + 2, rotationalFrequency),-rotationalMaxOffset.z, rotationalMaxOffset.z))); 
    }
    
    private float GetPerlinNoise(float seed, float frequency) => (Mathf.PerlinNoise(seed, Time.time * frequency) - 0.5f) * 2;
}
