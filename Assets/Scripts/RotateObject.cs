using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObject : MonoBehaviour {
    private Vector3 zeroPosition;

    void Start() {
        zeroPosition = transform.localPosition;
    }

    void Update() {
        transform.Rotate(0.0f, 0.25f, 0.0f, Space.World);
        // calls a sin() function with the input of time 
        // to generate up and down movement
        float y = Mathf.Sin(Time.time) / 8;
        transform.localPosition = zeroPosition + new Vector3(0, y, 0);
    }
}
