using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
    public Canvas YouWonScreen;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnTriggerEnter(Collider other) {
        // changes alpha of the whole canvasgroup to show
        // the text and white background
        YouWonScreen.GetComponent<CanvasGroup>().alpha = 1;
    }
}
