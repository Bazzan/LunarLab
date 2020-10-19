using System.Collections;
using UnityEditor;
using UnityEngine;

public class PlayerDie : MonoBehaviour
{
    public AudioSource die;

    [SerializeField] private float secondsToSpawn;
    [Header("VFX")]
    [SerializeField] private ParticleSystem sparks;
    [SerializeField] private float timeToDestroyParticles;
    [SerializeField] private GameObject explotionContainer;
    [Header("CameraShake")]
    [SerializeField] private float cameraShakeOnDeath;
    [SerializeField] private CameraController cameraController;
    
    private Rigidbody2D playerRigidbody2D;
    private CharacterController CharacterController;
    private Transform[] childrenTransforms;
    private bool isDying = false;
    private UnityEngine.InputSystem.PlayerInput inputModule;

    private void Awake()
    {
        playerRigidbody2D = GetComponent<Rigidbody2D>();
        CharacterController = GetComponent<CharacterController>();
        inputModule = GetComponent<UnityEngine.InputSystem.PlayerInput>();
        childrenTransforms = GetComponentsInChildren<Transform>();
    }
        

    private IEnumerator Die()
    {
        if (isDying) yield break;
        isDying = true;

        PlayDeathVFX();

        playerRigidbody2D.velocity = Vector2.zero;
        inputModule.enabled = false; //turns of the PlayerInput component for "secondsToSpawn" time

        SetChildrenActive(false);
        die.Play();

        cameraController.AddTrauma(cameraShakeOnDeath);


        yield return new WaitForSeconds(secondsToSpawn);

        inputModule.enabled = true;
        playerRigidbody2D.isKinematic = true;
        CharacterController.playerControlsNotActive = true;
        CheckPointManager.Instance.RespawnAtLastCheckPoint();

        SetChildrenActive(true);

        isDying = false;
    }

    private void PlayDeathVFX()
    {
        ParticleSystem sparksSystem = Instantiate(sparks, transform.position, Quaternion.identity);
        Destroy(sparksSystem.gameObject, timeToDestroyParticles);

        GameObject explotionGO = Instantiate(explotionContainer, transform.position, Quaternion.identity);
        Destroy(explotionGO, timeToDestroyParticles);
    }

    private void SetChildrenActive(bool active)
    {
        for (int i = 1; i < childrenTransforms.Length; i++)
        {
            childrenTransforms[i].gameObject.SetActive(active);
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        StartCoroutine(Die());
    }

}
