using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiHealth : MonoBehaviour
{
    public int health = 5;
    public Text healthText;

    private void Update()
    {
        healthText.text = "Health: " + health;

        if (Input.GetKeyDown(KeyCode.KeypadEnter)) //placeholder, switch with actual health removing funktion
        {
            health--;
        }
    }
}