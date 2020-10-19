using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiTimer : MonoBehaviour
{
    public float timeRemaining = 10;
    public Text timeText;
    public bool timeRunning = false;

    private void Start()
    {
        timeRunning = true;
    }

    void Update()
    {
       
        
        if (timeRunning)
        {
            if (timeRemaining > 0)
            {
                timeRemaining += Time.deltaTime;
                DisplayTime(timeRemaining);
            }
            else
            {
                timeRemaining = 0;
                timeRunning = false;
            }
        }
    }
    void DisplayTime(float timeDisplay)
    {
        timeDisplay += 1;

        float minutes = Mathf.FloorToInt(timeDisplay / 60);
        float seconds = Mathf.FloorToInt(timeDisplay % 60);

        timeText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
    }
}
