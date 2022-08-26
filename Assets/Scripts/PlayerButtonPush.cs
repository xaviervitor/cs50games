using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerButtonPush : MonoBehaviour {
    public LayerMask PushableLayer;
	public float PushForce = 120f;

    private void OnControllerColliderHit(ControllerColliderHit hit) {
		// Push only objects directly below the player
		if (hit.moveDirection.y >= 0f) return;
		// Push only objects in the Pushable layer
		Rigidbody rigidbody = hit.collider.attachedRigidbody;
		int rigidbodyLayerMask = 1 << hit.gameObject.layer;
		if ((rigidbodyLayerMask & PushableLayer.value) == 0) return;
        // Add force down
		rigidbody.AddForce(-Vector3.up * PushForce, ForceMode.Force);
	}
}
