using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSunDirection : MonoBehaviour
{
    public GameObject Sun;
    public Vector3 NewDirection = Vector3.zero;
    
    void OnTriggerEnter(Collider c) {
        if (c.gameObject.tag == "Player") {
            StartCoroutine(RotateSun());
        }
    }

    IEnumerator RotateSun() {
        Vector3 startValue = Sun.transform.eulerAngles;
        Vector3 targetValue = NewDirection;
        float duration = 1;
        float time = 0;
        while (time < duration) {
            Sun.transform.eulerAngles = Vector3.Lerp(startValue, targetValue, time / duration);
            // Slow down the transition so that the sun appears to be moving
            time += Time.deltaTime / 64;
            yield return null;
        }
        Sun.transform.eulerAngles = NewDirection;
        Destroy(gameObject);
    }
}
