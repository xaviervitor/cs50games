using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReactivateObjectOnTouch : MonoBehaviour
{
    private LayerMask layerHeld;
    private new Rigidbody rigidbody;
    // Start is called before the first frame update
    void Start()
    {
        layerHeld = LayerMask.NameToLayer("Held");
        rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (gameObject.layer == layerHeld) {
            rigidbody.constraints = RigidbodyConstraints.None;
        }
    }
}
