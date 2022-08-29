using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PressureButton : MonoBehaviour {
	public float springForce = 30f;
    public bool Pressed = false;

    private new Rigidbody rigidbody;
    private Vector3 unpressedPosition;

    void Start() {
        unpressedPosition = transform.localPosition;
        rigidbody = GetComponent<Rigidbody>();
    }

    void FixedUpdate() {
        // Adjusts the force according to the distance from the unpressed position
        // calculating a distance value from 0 to 1, where 0 means the button is 
        // fully unpressed and 1 means that the button is fully pressed, and 
        // multiplying this distance "percentage" with the up force   
        float distance = unpressedPosition.y - transform.localPosition.y;
        float distancePercentage = distance / unpressedPosition.y;
        if (transform.localPosition.y < unpressedPosition.y) {
            rigidbody.AddForce(transform.up * springForce * distancePercentage, ForceMode.Force);
        } else {
            rigidbody.velocity = Vector3.zero;
            transform.localPosition = unpressedPosition;
        }
        
        Pressed = distancePercentage >= 0.95;
    }
}
