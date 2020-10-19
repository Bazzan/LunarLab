using UnityEngine;
using UnityEditor;



[CustomEditor(typeof(GravityAffecter))]
public class GravityEditor : Editor
{
    public override void OnInspectorGUI()
    {
        GravityAffecter gravityObject = (GravityAffecter)target;
        string[] options = new string[] { "Player", "Gravity Objects" };

        //Will always Show
        EditorGUILayout.BeginVertical("box");

        #region Title

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Gravity Control", EditorStyles.boldLabel);   //Name of editor
        EditorGUILayout.LabelField("Affected Layers", GUILayout.Width(100));
        gravityObject.layers = (GravityAffecter.AffectedLayers)EditorGUILayout.EnumPopup(gravityObject.layers, GUILayout.Width(110));
        EditorGUILayout.EndHorizontal();
        #endregion

        EditorGUILayout.Space(5f);

        #region Min / Max (Text, Value, Slider)

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Min", GUILayout.Width(50));
        EditorGUILayout.LabelField("Max", GUILayout.Width(50));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        gravityObject.minForce = EditorGUILayout.FloatField(gravityObject.minForce, GUILayout.Width(50));
        gravityObject.maxForce = EditorGUILayout.FloatField(gravityObject.maxForce, GUILayout.Width(50));
        EditorGUILayout.EndHorizontal();

        gravityObject.force = EditorGUILayout.Slider(gravityObject.force, gravityObject.minForce, gravityObject.maxForce);
        #endregion

        EditorGUILayout.Space(5f);

        #region Reverse Gravity (Text, Toggle)

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Revese Gravity", GUILayout.Width(100));   //Name of editor
        gravityObject.negativeForce = EditorGUILayout.Toggle(gravityObject.negativeForce);
        EditorGUILayout.EndHorizontal();

        switch (gravityObject.layers)
        {
            case GravityAffecter.AffectedLayers.Player:
                {
                    gravityObject.detectionLayers = 1024;
                    break;
                }

            case GravityAffecter.AffectedLayers.GravityObject:
                {
                    gravityObject.detectionLayers = 2048;
                    break;
                }
        }

        #endregion

        EditorGUILayout.Space(10f);

        #region Gizmo Color (Color, Bool)

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Draw Gizmos", GUILayout.Width(100));
        gravityObject.drawGizmos = EditorGUILayout.Toggle(gravityObject.drawGizmos);
        EditorGUILayout.EndHorizontal();
        
        if (gravityObject.drawGizmos)
        {
            EditorGUILayout.BeginHorizontal();
            gravityObject.gizmoColors = EditorGUILayout.ColorField(gravityObject.gizmoColors);
            gravityObject.enableColor = EditorGUILayout.Toggle(gravityObject.enableColor);
            EditorGUILayout.EndHorizontal();
        }

        else
        {
            gravityObject.enableColor = false;
        }
        #endregion

        EditorGUILayout.EndVertical();

        EditorGUILayout.Space(10f);

        switch (gravityObject.forceType)
        {
            #region Circle Inspector

            case GravityAffecter.Force.Circle:
                {
                    GUILayout.BeginVertical("box");

                    #region Title (Text)

                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField("Force Type", EditorStyles.boldLabel);
                    gravityObject.forceType = (GravityAffecter.Force)EditorGUILayout.EnumPopup(gravityObject.forceType);
                    EditorGUILayout.EndHorizontal();
                    #endregion

                    EditorGUILayout.Space(5f);

                    #region Min/Max (Text, Value)

                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField("Min", GUILayout.Width(50));
                    EditorGUILayout.LabelField("Max", GUILayout.Width(50));
                    EditorGUILayout.EndHorizontal();

                    EditorGUILayout.BeginHorizontal();
                    gravityObject.minRadius = EditorGUILayout.FloatField(gravityObject.minRadius, GUILayout.Width(50));
                    gravityObject.maxRadius = EditorGUILayout.FloatField(gravityObject.maxRadius, GUILayout.Width(50));
                    EditorGUILayout.EndHorizontal();
                    #endregion

                    EditorGUILayout.Space(5f);

                    #region Inner Radius (Slider, text)

                    EditorGUILayout.LabelField("Inner Radius", GUILayout.Width(90));
                    gravityObject.radius =
                        EditorGUILayout.Slider(gravityObject.radius, gravityObject.minRadius, gravityObject.maxRadius);
                    #endregion

                    #region Outer Radius (Slider, text)

                    EditorGUILayout.LabelField("Outer Radius", GUILayout.Width(90));
                    gravityObject.transitionRadius =
                        EditorGUILayout.Slider(gravityObject.transitionRadius, gravityObject.minRadius, gravityObject.maxRadius);
                    #endregion

                    GUILayout.EndVertical();

                    break;
                }
            #endregion

            #region Square Inspector

            case GravityAffecter.Force.Square:
                {
                    GUILayout.BeginVertical("box");

                    #region Title (Text)

                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField("Force Type", EditorStyles.boldLabel);
                    gravityObject.forceType = (GravityAffecter.Force)EditorGUILayout.EnumPopup(gravityObject.forceType);
                    EditorGUILayout.EndHorizontal();
                    #endregion

                    EditorGUILayout.Space(5f);

                    #region Min/Max (Text, Value)

                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.LabelField("Min", GUILayout.Width(50));
                    EditorGUILayout.LabelField("Max", GUILayout.Width(50));
                    EditorGUILayout.EndHorizontal();

                    EditorGUILayout.BeginHorizontal();
                    gravityObject.minSize = EditorGUILayout.FloatField(gravityObject.minSize, GUILayout.Width(50));
                    gravityObject.maxSize = EditorGUILayout.FloatField(gravityObject.maxSize, GUILayout.Width(50));
                    EditorGUILayout.LabelField("Size", GUILayout.Width(50));
                    EditorGUILayout.EndHorizontal();

                    #endregion

                    EditorGUILayout.Space(5f);

                    #region X Value (Slider, text)

                    EditorGUILayout.LabelField("X - Value", GUILayout.Width(55));
                    gravityObject.centerSize.x =
                        EditorGUILayout.Slider(gravityObject.centerSize.x, gravityObject.minSize, gravityObject.maxSize);
                    #endregion

                    #region Y Value (Slider, Text)

                    EditorGUILayout.LabelField("Y - Value", GUILayout.Width(55));
                    gravityObject.centerSize.y =
                        EditorGUILayout.Slider(gravityObject.centerSize.y, gravityObject.minSize, gravityObject.maxSize);
                    #endregion

                    #region Angle (Slider, Text)

                    EditorGUILayout.LabelField("Force Direction", GUILayout.Width(100));
                    gravityObject.forceDirection =
                        EditorGUILayout.Slider(gravityObject.forceDirection, -90, 90);
                    #endregion

                    GUILayout.EndVertical();

                    break;
                }
                #endregion
        }
        //base.OnInspectorGUI();
    }

    private void OnSceneGUI()
    {
        GravityAffecter gravityObject = (GravityAffecter)target;
        gravityObject.arrowDirection = new Vector2(gravityObject.forceDirection, 90);

        switch (gravityObject.forceType)
        {
            case GravityAffecter.Force.Circle:
                {

                    if (gravityObject.enableColor)
                    {
                        //Center Area
                        Handles.color = new Color(gravityObject.gizmoColors.r, gravityObject.gizmoColors.g, gravityObject.gizmoColors.b, 0.2f);
                        Handles.DrawSolidDisc(gravityObject.transform.position, gravityObject.transform.forward, gravityObject.radius);

                        //Outer Area
                        Handles.color = new Color(gravityObject.gizmoColors.r, gravityObject.gizmoColors.g, gravityObject.gizmoColors.b, 0.1f);
                        Handles.DrawSolidDisc(gravityObject.transform.position, gravityObject.transform.forward, (gravityObject.transitionRadius + 1) * gravityObject.radius);
                    }

                    //Outlines
                    Handles.color = new Color(1f, 1f, 1f, 1f);
                    Handles.DrawWireDisc(gravityObject.transform.position, gravityObject.transform.forward, gravityObject.radius);
                    Handles.DrawWireDisc(gravityObject.transform.position, gravityObject.transform.forward, (gravityObject.transitionRadius + 1) * gravityObject.radius);

                    #region Handles Arrows
                    Handles.color = Color.white;

                    if (gravityObject.negativeForce)
                    {
                        //Top-Right Arrow
                        Handles.ArrowHandleCap(1, gravityObject.transform.position + new Vector3(3, -3, 0),
                            Quaternion.Euler(-45, -90, 0f), 3f, EventType.Repaint);

                        //Top-Left Arrow
                        Handles.ArrowHandleCap(0, gravityObject.transform.position + new Vector3(-3, 3, 0),
                            Quaternion.Euler(45f, 90, 0f), 3f, EventType.Repaint);

                        //Bottom-Left Arrow
                        Handles.ArrowHandleCap(0, gravityObject.transform.position + new Vector3(-3, -3, 0),
                            Quaternion.Euler(-45f, 90, 0f), 3f, EventType.Repaint);

                        //Bottom-Right Arrow
                        Handles.ArrowHandleCap(0, gravityObject.transform.position + new Vector3(3, 3, 0),
                            Quaternion.Euler(45f, -90, 0f), 3f, EventType.Repaint);
                    }

                    else
                    {
                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(45f, 90, 0f), 3f, EventType.Repaint);

                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(-45f, -90, 0f), 3f, EventType.Repaint);

                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(45f, -90, 0f), 3f, EventType.Repaint);

                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(-45f, 90, 0f), 3f, EventType.Repaint);
                    }
                    #endregion

                    break;
                }

            case GravityAffecter.Force.Square:
                {
                    if (gravityObject.negativeForce)
                    {
                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(new Vector2(gravityObject.forceDirection + 90, 90f)), 3f, EventType.Repaint);
                    }

                    else
                    {
                        Handles.ArrowHandleCap(0, gravityObject.transform.position,
                            Quaternion.Euler(new Vector2(gravityObject.forceDirection - 90, 90f)), 3f, EventType.Repaint);
                    }

                    Handles.color = new Color(1f, 1f, 1f, 0.4f);
                    Handles.DrawWireCube(gravityObject.transform.position, gravityObject.centerSize);
                    break;
                }
        }
    }
}
