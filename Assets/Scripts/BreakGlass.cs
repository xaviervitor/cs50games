using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreakGlass : MonoBehaviour
{
    private new Collider collider;
    private List<Rigidbody> childrenRigidbodies;
    void Start() {
        collider = GetComponent<Collider>();
        childrenRigidbodies = new List<Rigidbody>();
        foreach (Transform child in transform) {
            childrenRigidbodies.Add(child.GetComponent<Rigidbody>());
        }
    }

    void OnTriggerEnter(Collider c) {
        Rigidbody rb = c.attachedRigidbody;
        if (rb) {
            if (rb.velocity.magnitude > 10) {
                foreach (Rigidbody childrenRigidbody in childrenRigidbodies) {
                    childrenRigidbody.constraints = RigidbodyConstraints.None;
                    childrenRigidbody.mass = 0.01f;
                }
                collider.enabled = false;
                StartCoroutine(OptimizeCollision());
            }
        }
    }

    IEnumerator OptimizeCollision() {
        yield return new WaitForSeconds(2);
        foreach (Rigidbody childrenRigidbody in childrenRigidbodies) {
            childrenRigidbody.collisionDetectionMode = CollisionDetectionMode.Discrete;
        }
    }
}
