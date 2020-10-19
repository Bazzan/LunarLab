using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class GravityFlipper : MonoBehaviour
{
    [SerializeField] float flipTime = 0;
    [SerializeField] UnityEvent eventOne;
    [SerializeField] UnityEvent eventTwo;

    public bool shouldFlip = true;

    float timer = 0;
    bool triggered;

    private void Update()
    {
        if (shouldFlip && timer >= flipTime)
        {
            if (triggered)
            {
                eventOne.Invoke();
            }
            else
            {
                eventTwo.Invoke();
            }

            timer = 0;
            triggered = !triggered;

        }
        else timer += Time.deltaTime;
    }

    [SerializeField] GravityAffecter gravityAffecter = null;
    public void FlipGravityDirection()
    {
        gravityAffecter.negativeForce = !gravityAffecter.negativeForce;
    }

    [SerializeField] Transform transformToFlip = null;
    public void FlipTransform()
    {
        transformToFlip.Rotate(0, 0, 180);
    }

}
