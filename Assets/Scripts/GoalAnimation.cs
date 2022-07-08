using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoalAnimation : MonoBehaviour
{
    public float RotationAngle = 1;
    public float UpDownAmplitude = 1;
    private Vector3 zeroPosition;
    
    // Start is called before the first frame update
    void Start()
    {
        zeroPosition = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0.0f, RotationAngle, 0.0f);
        // calls a sin() function with the input of time 
        // to generate up and down movement
        float y = Mathf.Sin(Time.time) * UpDownAmplitude;
        transform.position = zeroPosition + new Vector3(0, y, 0);
    }
}
