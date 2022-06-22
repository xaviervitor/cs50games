using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{
    public GameObject gem;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SpawnGems());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator SpawnGems() {
        while(true) {
            Instantiate(gem, new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
            yield return new WaitForSeconds(Random.Range(5.5f, 15.5f));
        }
    }
}
