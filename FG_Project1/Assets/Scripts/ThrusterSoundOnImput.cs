using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThrusterSoundOnImput : MonoBehaviour
{
    public AudioSource thruster;
    PlayerInput playerInput;

    private void Awake()
    {
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
                thruster.Play();
                playing = true;
            }
        }
        else
        {
            playing = false;
            thruster.Stop();
        }
    }
}
    

