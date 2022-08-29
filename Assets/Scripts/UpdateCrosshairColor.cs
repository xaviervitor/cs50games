using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

namespace StarterAssets {
	public class UpdateCrosshairColor : MonoBehaviour {
		[Header("Reference objects")]
		public GameObject Crosshair;
		[Header("Crosshair colors")]
		public Color CrosshairColorDefault;
		public Color CrosshairColorPickable;
		public Color CrosshairColorMagnetic;
		private Image crosshairImage;
		
		// Start is called before the first frame update
		void Start() {
			crosshairImage = Crosshair.GetComponent<Image>();
		}

		// Update is called once per frame
		void Update() {
			if (PlayerInteract.CurrentCrosshairColor == PlayerInteract.CrosshairColor.Pickable)
				crosshairImage.color = CrosshairColorPickable;
			else if (PlayerInteract.CurrentCrosshairColor == PlayerInteract.CrosshairColor.Magnetic)
				crosshairImage.color = CrosshairColorMagnetic;
			else
				crosshairImage.color = CrosshairColorDefault;
		}
	}
}