using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gem : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.x < -25) {
            Destroy(gameObject);
        } else {
            transform.Translate(-SkyscraperSpawner.speed * Time.deltaTime, 0, 0, Space.World);
            transform.Rotate(Vector3.up * 1);
        }
    }

    void OnTriggerEnter(Collider other) {
        other.transform.parent.GetComponent<HeliController>().PickupGem();
        Destroy(gameObject);
    }
}
