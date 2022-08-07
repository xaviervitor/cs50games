using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

namespace StarterAssets {
	[RequireComponent(typeof(CharacterController))]
	[RequireComponent(typeof(PlayerInput))]
	public class PlayerInteract : MonoBehaviour {
		public enum CrosshairColor {Pickable, Magnetic, Default};
		public static CrosshairColor CurrentCrosshairColor = CrosshairColor.Default;

		[Header("Reference objects")]
		public GameObject PlayerCameraRotation;
		public GameObject GroundIndicatorPrefab;
		public Material HeldMaterial;
		[Header("Raycasting")]
		public LayerMask InteractLayers;
		public float RaycastPickableDistance = 2.50f;
		[Header("Object pull")]
		public float PullSpeed = 10.0f;
		public float PullSlowDownDistance = 5.0f;
		private StarterAssetsInputs input;
		private bool isMouseDown = false;
		private HeldObject heldObject = null;
		private int layerPickable;
		private int layerMagnetic;
		private int layerHeld;
		
		private void Start() {
			input = GetComponent<StarterAssetsInputs>();
			layerPickable = LayerMask.NameToLayer("Pickable");
			layerMagnetic = LayerMask.NameToLayer("Magnetic");
			layerHeld = LayerMask.NameToLayer("Held");
		}

		private void FixedUpdate() {
			PushOrPullObject();
			MoveHeldObject();
			GameObject hitGameObject = RaycastObjectInRange();
			PickupOrReleaseObject(hitGameObject);
		}

		private void PickupOrReleaseObject(GameObject hitGameObject) {
			// Detects the player input and stores the value read at the 
			// previous frame in the variable isMouseDown, making the 
			// pickup/drop code only once per click.
			if (input.interact) {
				if (isMouseDown) return;
				if (heldObject != null)
					ReleaseObject();
				else
					PickupObject(hitGameObject);
				isMouseDown = input.interact; // always true
			} else {
				isMouseDown = input.interact; // always false
			}
		}

		private void PushOrPullObject() {
			if (heldObject != null && heldObject.originalLayer == layerMagnetic) {
				if (input.changeHeldObjectDistance > 0) {
					heldObject.playerToObjectDistance += 0.25f;
				} else if (input.changeHeldObjectDistance < 0) {
					heldObject.playerToObjectDistance -= 0.25f;
				}
			}
		}

		private void MoveHeldObject() {
			if (heldObject != null) {
				heldObject.rigidbody.angularVelocity = Vector3.zero;
				Vector3 targetPosition = PlayerCameraRotation.transform.position + 
						PlayerCameraRotation.transform.forward * heldObject.playerToObjectDistance;

				float distance = Vector3.Distance(heldObject.gameObject.transform.position, targetPosition);
				Vector3 pullDirection = targetPosition - heldObject.gameObject.transform.position;
				heldObject.rigidbody.AddForce(pullDirection.normalized * distance * PullSpeed, ForceMode.VelocityChange);
			}
		}

		private GameObject RaycastObjectInRange() {
			RaycastHit hit;
			GameObject hitGameObject;
			Ray ray = new Ray(PlayerCameraRotation.transform.position, PlayerCameraRotation.transform.forward);
			if (Physics.Raycast(ray, out hit, InteractLayers)) {
				hitGameObject = hit.transform.gameObject;
				if (hitGameObject.layer == layerMagnetic)
					CurrentCrosshairColor = CrosshairColor.Magnetic;
				else if (hitGameObject.layer == layerPickable && hit.distance <= RaycastPickableDistance)
					CurrentCrosshairColor = CrosshairColor.Pickable;
				else {
					// When a object leaves the range but the crosshair 
					// keeps looking at it
					CurrentCrosshairColor = CrosshairColor.Default;
					return null;
				}
			} else {
				// When the crosshair is pointed at an object and its pointed 
				// at another object outside of the InteractLayers right after
				CurrentCrosshairColor = CrosshairColor.Default;
				return null;
			}
			return hitGameObject;
		}

		private void PickupObject(GameObject hitGameObject) {
			if (!hitGameObject) return;
			heldObject = new HeldObject(hitGameObject);
			GameObject groundIndicatorInstance = (GameObject) Instantiate(GroundIndicatorPrefab);
			heldObject.Pickup(groundIndicatorInstance, layerHeld, HeldMaterial);
		}

		private void ReleaseObject() {
			heldObject.Release();
			Destroy(heldObject.groundIndicator);
			heldObject = null;
		}
	}
}