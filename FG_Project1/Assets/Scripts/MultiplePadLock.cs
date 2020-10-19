using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MultiplePadLock : MonoBehaviour
{
    [SerializeField] Light[] lights;
    [SerializeField] Color lockedColor;
    [SerializeField] Color openColor;
    [SerializeField] UnityEvent openEvent;
    bool[] locks;



    private void Awake()
    {
        locks = new bool[lights.Length];
        lockedColor = lights[0].color;
        for (int i = 0; i < locks.Length; i++)
        {
            locks[i] = true;
        }
    }

    public void UnlockLock(int index)
    {
        locks[index] = false;
        lights[index].color = openColor;

        bool stillLocked = false;
        for (int i = 0; i < locks.Length; i++)
        {
            if (locks[i])
            {
                stillLocked = true;
                break;
            }
        }

        if (!stillLocked)
        {
            openEvent.Invoke();
        }

    }

}
