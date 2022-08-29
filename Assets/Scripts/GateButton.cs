using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GateButton : MonoBehaviour {
    public GameObject ButtonPressurePlate;
    public Vector3 openedPosition;
    public float pullForce = 30f;
    public bool reversed = false;
    private new Rigidbody rigidbody;
    private PressureButton pressureButton;
    private Vector3 closedPosition;

    void Start() {
        rigidbody = GetComponent<Rigidbody>();
        pressureButton = ButtonPressurePlate.GetComponent<PressureButton>();
        closedPosition = transform.localPosition;
    }

    void FixedUpdate() {
        bool isButtonPressed = pressureButton.Pressed;
        if (reversed) isButtonPressed = !isButtonPressed;

        if (isButtonPressed) {
            if (transform.localPosition.y < openedPosition.y) {
                rigidbody.AddForce(transform.up * pullForce, ForceMode.Force);
            }
        }
    }
}
