using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class UpdateText : MonoBehaviour
{
    public TMP_Text currentFloorText;

    // Start is called before the first frame update
    void Start()
    {
        currentFloorText.text = $"<margin=0.25em><voffset=-0.25em>Floor: {LevelGenerator.currentFloor}";
    }
}
