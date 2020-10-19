using UnityEngine;

public class HighSpeedVFX : MonoBehaviour
{

    [SerializeField] private ParticleSystem smoke;
    [SerializeField] private ParticleSystem shipSparks;
    [SerializeField] private GameObject hullShader;
    [SerializeField] private float speedToPlaySmoke;
    [SerializeField] private float speedToPlayHullFire;
    [SerializeField] private float speedToPlaySparks;
    [SerializeField] private float dotAngel;


    private float dot;
    private Rigidbody2D playerBody;


    private void Awake()
    {
        playerBody = GetComponentInParent<Rigidbody2D>();

    }

    private void LateUpdate()
    {
        dot = Vector2.Dot(playerBody.velocity.normalized, playerBody.transform.up);


        if (playerBody.velocity.magnitude > speedToPlaySmoke && dot > dotAngel) { 
            if (!smoke.isPlaying)
                smoke.Play();
        }
        else
            if (smoke.isPlaying)
                smoke.Stop();

        if (playerBody.velocity.magnitude > speedToPlayHullFire && dot > dotAngel) { 
            if (!hullShader.active)

                hullShader.SetActive(true);

        }
        else 
            if (hullShader.active)
                hullShader.SetActive(false);


        if (playerBody.velocity.magnitude > speedToPlaySparks && dot > dotAngel) { 
            if (!shipSparks.isPlaying)
                shipSparks.Play();
        }
        else 
            if (shipSparks.isPlaying)
                shipSparks.Stop();






    }

}
