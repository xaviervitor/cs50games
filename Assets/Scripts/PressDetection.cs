using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PressDetection : MonoBehaviour
{
    public Vector3 PressedOffset;
    public bool Pressed = false;
    private Vector3 initialPosition;
    
    // Start is called before the first frame update
    void Start()
    {
        initialPosition = transform.position;
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter(Collider c)
	{
        Pressed = true;
        transform.position = initialPosition - PressedOffset;
	} 
    
    void OnTriggerExit(Collider c)
    {
        Pressed = false;
        transform.position = initialPosition;
    }
}
