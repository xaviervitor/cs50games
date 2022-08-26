using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObtainOnTouch : MonoBehaviour {

    private Light pointLight;
    private Renderer meshRenderer;
    private Rigidbody parentRigidbody;
    private Collider parentCollider;
    
    void Start() {
        pointLight = GetComponent<Light>();
        meshRenderer = GetComponent<Renderer>();
        parentRigidbody = transform.parent.transform.GetComponent<Rigidbody>();
        parentCollider = transform.parent.transform.GetComponent<Collider>();
    }

    void OnTriggerEnter(Collider c) {
        if (c.gameObject.tag == "Player") {
            PlayerProgression.hasMagneticBracelet = true;
            meshRenderer.enabled = false;
            StartCoroutine(FadeLight());
            StartCoroutine(MoveAltarDown());
        }
    }

    IEnumerator FadeLight() {
        float startValue = pointLight.intensity;
        float targetValue = 0;
        float duration = 2;
        float time = 0;
        while (time < duration) {
            pointLight.intensity = Mathf.Lerp(startValue, targetValue, time / duration);
            time += Time.deltaTime;
            yield return null;
        }
        pointLight.intensity = targetValue;
        Destroy(gameObject);
    }

    IEnumerator MoveAltarDown() {
        Destroy(parentRigidbody);
        Destroy(parentCollider);
        float startValue = transform.parent.transform.position.y;
        float targetValue = transform.parent.transform.position.y - 1f;
        Vector3 newPosition = transform.parent.position;
        float duration = 2;
        float time = 0;
        while (time < duration) {
            newPosition.y = Mathf.Lerp(startValue, targetValue, time / duration);
            transform.parent.position = newPosition;
            time += Time.deltaTime;
            yield return null;
        }
        newPosition.y = targetValue;
        transform.parent.position = newPosition;
    }
}
