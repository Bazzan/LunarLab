using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SPIN : MonoBehaviour
{
    [SerializeField] float speed = 5;
    // Start is called before the first frame update
    void Start()
    {
        transform.eulerAngles = new Vector3(0, 0, Random.Range(0, 360));
    }

    private void LateUpdate()
    {
        transform.Rotate(new Vector3(0, 0, speed * Time.deltaTime));

    }

}
