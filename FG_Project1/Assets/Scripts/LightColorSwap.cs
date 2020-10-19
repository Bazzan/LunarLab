using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(Light))]
public class LightColorSwap : MonoBehaviour
{
    Color startColor;
    Light light;
    [SerializeField] Color secondaryColor;


    private void Awake()
    {
        light = GetComponent<Light>();
    }

    public void SwapColor()
    {
        light.color = secondaryColor;
        secondaryColor = startColor;
        startColor = light.color;
    }


}
