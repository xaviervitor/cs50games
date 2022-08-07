using UnityEngine;

public class HeldObject {	
    public GameObject gameObject { get; set; }
    public Rigidbody rigidbody { get; set; }
    public float originalDrag { get; set; }
    public MeshRenderer meshRenderer { get; set; }
    public Material originalMaterial { get; set; }
    public int originalLayer { get; set; }
    public float playerToObjectDistance { get; set; }
    public Quaternion originalRotation { get; set; }
    public GameObject groundIndicator { get; set; }

    public HeldObject(GameObject _gameObject) {
        gameObject = _gameObject;
    }

    public void Pickup(GameObject groundIndicatorInstance, int layerHeld, Material heldMaterial) {
        rigidbody = gameObject.GetComponent<Rigidbody>();
        meshRenderer = gameObject.GetComponent<MeshRenderer>();
        originalLayer = gameObject.layer;
        originalDrag = rigidbody.drag;
        originalMaterial = meshRenderer.material;
        Mesh objMesh = gameObject.GetComponent<MeshFilter>().mesh;
        float averageSize = (objMesh.bounds.size.x + objMesh.bounds.size.y + objMesh.bounds.size.z) / 3;
        // Object distance is 2^x + c where x is the x, y and z average
        // bounds of the object and c is just a constant.
        float distance = Mathf.Pow(2, averageSize) + 0.5f;
		playerToObjectDistance = distance;
        groundIndicator = groundIndicatorInstance;
        groundIndicator.GetComponent<PlaceAndScaleIndicator>().followGameObject = gameObject;
        rigidbody.useGravity = false;
        rigidbody.drag = 20;
        originalRotation = gameObject.transform.localRotation;
        // Change material to transparent
        Color color = meshRenderer.material.color;
        color.a = 0.5f;
        meshRenderer.material = heldMaterial;
        meshRenderer.material.color = color;
        // Changes the physics layer of the object to not let the player 
        // consider it as ground while the object is being held
        gameObject.layer = layerHeld;
    }

    public void Release() {
        // Changes the physics layer of the object to let the player 
        // consider it as ground again
        gameObject.layer = originalLayer;
        // Changes object alpha back
        meshRenderer.material = originalMaterial;
        rigidbody.useGravity = true;
        rigidbody.drag = originalDrag;
        float dropThreshold = 1.0f;
        if (rigidbody.velocity.magnitude < dropThreshold) {
            // Drop object
            // Reset angular velocity only if the 
            // player places an object, as the angular velocity
            // increases the sense of force when the player is 
            // throwing objects.
            rigidbody.velocity = Vector3.zero;
            rigidbody.angularVelocity = Vector3.zero;
        }
    }
}