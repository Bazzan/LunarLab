using UnityEngine;

public class PlayAllVFX : MonoBehaviour
{

    [SerializeField] private ParticleSystem[] particleSystems;


    private void Awake()
    {

        particleSystems = GetComponentsInChildren<ParticleSystem>();
        
    }
    private void Start()
    {
        foreach (ParticleSystem particleSystem in particleSystems)
        {
            particleSystem.Play();
        }
    }




}
