using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{

    // Update is called once per frame
    void Update()
    {
        if (gameObject.transform.position.y < -2) {
            LevelGenerator.currentFloor = 0;
            SceneManager.LoadScene("GameOver");
        }
    }
}
