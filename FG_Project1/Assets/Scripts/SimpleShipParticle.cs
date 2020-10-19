using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleShipParticle : MonoBehaviour
{
    [SerializeField] ParticleSystem shipParticles;
    [SerializeField] Light light;
    float lightMaxIntensity;
    PlayerInput playerInput;
    [SerializeField] float lightFade = 1f;


    private void Awake()
    {
        lightMaxIntensity = light.intensity;
        playerInput = GetComponent<PlayerInput>();
    }

    bool playing = false;
    // Update is called once per frame
    void Update()
    {
        if (playerInput.Thrust > .2)
        {
            if (!playing)
            {
                shipParticles.Play();
                playing = true;
            }
            if (light != null)
                light.intensity = Mathf.Lerp(light.intensity, lightMaxIntensity * playerInput.Thrust, lightFade * Time.deltaTime);
        }
        else
        {
            if (light != null)
                light.intensity = Mathf.Lerp(light.intensity, 0, lightFade * Time.deltaTime);
            playing = false;
            shipParticles.Stop();
        }
    }
}
