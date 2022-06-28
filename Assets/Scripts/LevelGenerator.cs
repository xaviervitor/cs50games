using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelGenerator : MonoBehaviour {

	public GameObject floorPrefab;
	public GameObject wallPrefab;
	public GameObject ceilingPrefab;

	public GameObject characterController;

	public GameObject floorParent;
	public GameObject wallsParent;
	public GameObject holesParent;

	// allows us to see the maze generation from the scene view
	public bool generateRoof = true;

	// number of times we want to "dig" in our maze
	public int tilesToRemove = 50;

	public int maxFloorHoles = 4;

	public int mazeSize;

	// spawns at the end of the maze generation
	public GameObject pickup;

	// this will determine whether we've placed the character controller
	private bool characterPlaced = false;

	// 2D array representing the map
	private int[,] mapData;

	// we use these to dig through our maze and to spawn the pickup at the end
	private int mazeX = 4, mazeY = 1;

	public static int currentFloor = 0;

	// Use this for initialization
	void Start () {

		// initialize map 2D array
		mapData = GenerateMazeData();

		// create actual maze blocks from maze boolean data
		for (int z = 0; z < mazeSize; z++) {
			for (int x = 0; x < mazeSize; x++) {
				if (mapData[z, x] == 1) {
					// creates ground to make the pit spawning easier,
					// ensuring that the ground (0) always exists.
					CreateChildPrefab(floorPrefab, wallsParent, x, 0, z);
					CreateChildPrefab(wallPrefab, wallsParent, x, 1, z);
					CreateChildPrefab(wallPrefab, wallsParent, x, 2, z);
					CreateChildPrefab(wallPrefab, wallsParent, x, 3, z);
				} else if (mapData[z, x] == -1) {
					// create walls around holes with a depth of 6 to
					// make a seemingly bottomless pit, spawning a 
					// floor to make the fog effect work correctly.
					int depth = 6;
					// right wall
					if (mapData[z + 1, x] != -1)
						for (int i = 1 ; i <= depth ; i++)
							CreateChildPrefab(floorPrefab, holesParent, x, -i, z + 1);
					// left wall
					if (mapData[z - 1, x] != -1)
						for (int i = 1 ; i <= depth ; i++)
							CreateChildPrefab(floorPrefab, holesParent, x, -i, z - 1);
					// up wall		
					if (mapData[z, x + 1] != -1)
						for (int i = 1 ; i <= depth ; i++)
							CreateChildPrefab(floorPrefab, holesParent, x + 1, -i, z);
					// down wall	
					if (mapData[z, x - 1] != -1)
						for (int i = 1 ; i <= depth ; i++)
							CreateChildPrefab(floorPrefab, holesParent, x - 1, -i, z);
					
					// floor at the bottom
					CreateChildPrefab(floorPrefab, holesParent, x, -depth - 1, z);
				} else if (mapData[z, x] == 0) {
					// create floor
					CreateChildPrefab(floorPrefab, floorParent, x, 0, z);
				
					if (!characterPlaced && z != mazeY && x != mazeX) {
						
						// place the character controller on the first empty wall we generate
						characterController.transform.SetPositionAndRotation(
							new Vector3(x, 1, z), Quaternion.identity
						);

						// flag as placed so we never consider placing again
						characterPlaced = true;
					} 
				}
				
				// create ceiling
				if (generateRoof) {
					CreateChildPrefab(ceilingPrefab, wallsParent, x, 4, z);
				}
			}
		}

		// spawn the pickup at the end
		var myPickup = Instantiate(pickup, new Vector3(mazeX, 1, mazeY), Quaternion.identity);
		myPickup.transform.localScale = new Vector3(0.25f, 0.25f, 0.25f);
	}

	// generates the booleans determining the maze, which will be used to construct the cubes
	// actually making up the maze
	int[,] GenerateMazeData() {
		int[,] data = new int[mazeSize, mazeSize];

		// initialize all walls to true
		for (int y = 0; y < mazeSize; y++) {
			for (int x = 0; x < mazeSize; x++) {
				data[y, x] = 1;
			}
		}

		// counter to ensure we consume a minimum number of tiles
		int tilesConsumed = 0;

		int holesCreated = 0;
		// iterate our random crawler, clearing out walls and straying from edges
		while (tilesConsumed < tilesToRemove) {
			
			// directions we will be moving along each axis; one must always be 0
			// to avoid diagonal lines
			int xDirection = 0, yDirection = 0;

			if (Random.value < 0.5) {
				xDirection = Random.value < 0.5 ? 1 : -1;
			} else {
				yDirection = Random.value < 0.5 ? 1 : -1;
			}

			// random number of spaces to move in this line
			int numSpacesMove = (int)(Random.Range(1, mazeSize - 1));

			// move the number of spaces we just calculated, clearing tiles along the way
			for (int i = 0; i < numSpacesMove; i++) {
				mazeX = Mathf.Clamp(mazeX + xDirection, 1, mazeSize - 2);
				mazeY = Mathf.Clamp(mazeY + yDirection, 1, mazeSize - 2);

				if (data[mazeY, mazeX] == 1) {
					data[mazeY, mazeX] = 0;
					tilesConsumed++;
				}
			}
		}

		// Spawns floor holes until maxFloorHoles is reached or the while 
		// loop runs (maxFloorHoles * 2) times, to prevent a infinite loop.
		int maxTries = maxFloorHoles * 2;
		int tries = 0;
		while (holesCreated < maxFloorHoles && tries < maxTries) {
			int x = Random.Range(1, mazeSize - 2);
			int y = Random.Range(1, mazeSize - 2);
			if (data[x, y] == 0) {
				data[x, y] = -1;
				holesCreated++;
			}
			tries++;
		}

		return data;
	}

	// allow us to instantiate something and immediately make it the child of this game object's
	// transform, so we can containerize everything. also allows us to avoid writing Quaternion.
	// identity all over the place, since we never spawn anything with rotation
	void CreateChildPrefab(GameObject prefab, GameObject parent, int x, int y, int z) {
		var myPrefab = Instantiate(prefab, new Vector3(x, y, z), Quaternion.identity);
		myPrefab.transform.parent = parent.transform;
	}
}
