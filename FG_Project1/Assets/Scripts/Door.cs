using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[SelectionBase]
public class Door : MonoBehaviour
{
    public bool startOpen = false;
    public AudioSource openSound;
    Animator animator;
    private void Awake()
    {
        animator = GetComponent<Animator>();
        if (startOpen) OpenNoSound();

    }

    public void OpenNoSound()
    {
        animator.SetBool("open", true);
    }

    public void OpenDoor()
    {
        if (!animator.GetBool("open"))
            openSound.Play();
        animator.SetBool("open", true);

    }
    public void CloseDoor()
    {
        animator.SetBool("open", false);
    }


}
