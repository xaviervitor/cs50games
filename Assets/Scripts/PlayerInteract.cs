using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

namespace StarterAssets {
	[RequireComponent(typeof(CharacterController))]
	[RequireComponent(typeof(PlayerInput))]
	public class PlayerInteract : MonoBehaviour
	{
		public LayerMask interactLayers;
		private StarterAssetsInputs _input;
		public GameObject PlayerCameraRotation;
		public GameObject ObjectsContainer;
		private bool isMouseDown = false;
		private GameObject heldObject;
		private Rigidbody heldObjectRigidbody;	
		private float playerToObjectDistance = 2;
		private float heldObjectColorAlpha = 0.5f;
		private Quaternion heldObjectInitialRotation;
		
		private void Start() {
			_input = GetComponent<StarterAssetsInputs>();
		}

		private void Update()
		{
			// Detects the player input and stores the value read at the 
			// previous frame in the variable isMouseDown, making the 
			// pickup/drop code only once per click.
			if (_input.interact) {
				if (isMouseDown) return;
				if (heldObject) {
					DropObject();
				} else {
					// Pick object
					RaycastHit hit;
					if (Physics.Raycast(PlayerCameraRotation.transform.position, PlayerCameraRotation.transform.forward, out hit, playerToObjectDistance, interactLayers)) {
						int layerPickable = LayerMask.NameToLayer("Pickable");
						GameObject hitGameObject = hit.transform.gameObject;
						if (hitGameObject.layer == layerPickable) {
							HoldObject(hitGameObject);
						}
					}
				}
				isMouseDown = _input.interact; // always true
			} else {
				isMouseDown = _input.interact; // always false
			}
		}
		
		private void FixedUpdate() {
			if (heldObject) {
				heldObject.transform.position = PlayerCameraRotation.transform.position + PlayerCameraRotation.transform.forward * playerToObjectDistance;
				heldObject.transform.localRotation = heldObjectInitialRotation;
			}
		}

		private void HoldObject(GameObject hitGameObject) {
			heldObject = hitGameObject;
			heldObjectRigidbody = heldObject.GetComponent<Rigidbody>();
			heldObject.GetComponent<Rigidbody>().useGravity = false;
			heldObject.transform.SetParent(PlayerCameraRotation.transform);
			heldObjectInitialRotation = heldObject.transform.localRotation;
			Color color = heldObject.GetComponent<MeshRenderer>().material.color;
			color.a = heldObjectColorAlpha;
			heldObject.GetComponent<MeshRenderer>().material.color = color;
			// Changes the physics layer of the object to not let the player 
			// consider it as ground while the object is being held
			heldObject.layer = LayerMask.NameToLayer("Held");
		}

		private void DropObject() {
			Color color = heldObject.GetComponent<MeshRenderer>().material.color;
			color.a = 1.0f;
			heldObject.GetComponent<MeshRenderer>().material.color = color;
			heldObject.transform.SetParent(ObjectsContainer.transform);
			heldObjectRigidbody.useGravity = true;
			// Applies force to object if the player is running
			if (_input.sprint) {
				heldObjectRigidbody.AddForce(PlayerCameraRotation.transform.forward, ForceMode.Impulse);
			}
			// Changes the physics layer of the object to let the player 
			// consider it as ground again
			heldObject.layer = LayerMask.NameToLayer("Pickable");
			heldObjectRigidbody = null;
			heldObject = null;
		}
	}
}