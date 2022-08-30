using UnityEngine;

public class HeldObject {	
    public GameObject gameObject { get; set; }
    public Rigidbody rigidbody { get; set; }
    public float originalDrag { get; set; }
    public MeshRenderer meshRenderer { get; set; }
    public Material originalMaterial { get; set; }
    public int originalLayer { get; set; }
    public float initialPlayerToObjectDistance { get; set; }
    public float playerToObjectDistance { get; set; }
    public Quaternion originalRotation { get; set; }
    public GameObject groundIndicator { get; set; }

    public HeldObject(GameObject _gameObject) {
        gameObject = _gameObject;
    }

    private void Pickup(GameObject groundIndicatorInstance, int layerHeld, Material heldMaterial) {
        rigidbody = gameObject.GetComponent<Rigidbody>();
        meshRenderer = gameObject.GetComponent<MeshRenderer>();
        originalLayer = gameObject.layer;
        originalDrag = rigidbody.drag;
        groundIndicator = groundIndicatorInstance;
        groundIndicator.GetComponent<PlaceAndScaleIndicator>().followGameObject = gameObject;
        rigidbody.useGravity = false;
        rigidbody.drag = 20;
        originalRotation = gameObject.transform.localRotation;
        // Change material to transparent
        originalMaterial = meshRenderer.material;
        Color color = meshRenderer.material.color;
        color.a = 0.5f;
        meshRenderer.material = heldMaterial;
        meshRenderer.material.CopyPropertiesFromMaterial(originalMaterial);
        ChangeRenderingModeToFade(meshRenderer.material);
        meshRenderer.material.SetColor("_Color", color);

        // Changes the physics layer of the object to not let the player 
        // consider it as ground while the object is being held
        gameObject.layer = layerHeld;
    }

    public void PickupAtDistance(Vector3 playerPosition, GameObject groundIndicatorInstance, int layerHeld, Material heldMaterial) {
        Pickup(groundIndicatorInstance, layerHeld, heldMaterial);
        playerToObjectDistance = Vector3.Distance(gameObject.transform.position, playerPosition);
        
    }

    public void PickupAttract(GameObject groundIndicatorInstance, int layerHeld, Material heldMaterial) {
        Pickup(groundIndicatorInstance, layerHeld, heldMaterial);
        Mesh objMesh = gameObject.GetComponent<MeshFilter>().mesh;
        float averageSize = (objMesh.bounds.size.x + objMesh.bounds.size.y + objMesh.bounds.size.z) / 3;
        // Object distance is 2^x + c where x is the x, y and z average
        // bounds of the object and c is just a constant.
        float distance = Mathf.Pow(2, averageSize);
        playerToObjectDistance = distance;
		initialPlayerToObjectDistance = distance;
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

    // Thanks to the user "berkhulagu" in the Unity forums.
    // This function does what the Unity editor does to 
    // change the material rendering the fade mode when the user
    // clicks the dropdown. 
    // https://forum.unity.com/threads/change-rendering-mode-via-script.476437/
    private void ChangeRenderingModeToFade(Material material) {
        material.SetOverrideTag("RenderType", "Transparent");
        material.SetInt("_SrcBlend", (int) UnityEngine.Rendering.BlendMode.SrcAlpha);
        material.SetInt("_DstBlend", (int) UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
        material.SetInt("_ZWrite", 0);
        material.DisableKeyword("_ALPHATEST_ON");
        material.EnableKeyword("_ALPHABLEND_ON");
        material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
        material.renderQueue = (int) UnityEngine.Rendering.RenderQueue.Transparent;
    }
}