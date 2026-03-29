import { Environment, useGLTF } from "@react-three/drei";
import { Canvas, useFrame, useThree } from "@react-three/fiber";
import {
	Bloom,
	EffectComposer,
	ToneMapping,
} from "@react-three/postprocessing";
import { createFileRoute } from "@tanstack/react-router";
import { Suspense, useEffect, useRef, useState } from "react";
import * as THREE from "three";
import { Button } from "#/components/ui/button";
import { connectLidarSocket, type LidarProduct } from "#/lib/lidar-data";

export const Route = createFileRoute("/lidar")({
	component: LidarPage,
});

const PRODUCT_NAMES: Record<string, string> = {
	armor_all: "Armor All Protectant Wipes",
	hot_shine: "Meguiar's Hot Shine Tire Spray",
	leather_solution: "Sof Sole Leather Solution",
	engraving_kit: "Dremel Carving/Engraving Accessory Kit",
	ozark_trail: "Ozark Trail 24oz Loop Water Bottle",
};

type CamPose = {
	position: [number, number, number];
	target: [number, number, number];
	center: [number, number, number];
};

const DEFAULT_CAMERA: CamPose = {
	position: [2.55, -0.19, -0.84],
	target: [-2.04, -0.77, -0.81],
	center: [-2.04, -0.77, -0.81],
};

const CAMERA_DISTANCE = 0.8;

// Manual center overrides for meshes where bounding box calculation is off
const CENTER_OVERRIDES: Record<string, [number, number, number]> = {
	hot_shine: [0.29, 0.03, -0.44],
	armor_all: [0.48, -1.18, -0.43],
	ozark_trail: [0.34, 0.04, -1.32],
	// engraving_kit bbox has stray verts spanning two shelves — pin to actual product location
	engraving_kit: [0.41, -0.45, -1.15],
};

/** Compute camera poses from mesh bounding boxes */
function buildCamerasFromScene(
	scene: THREE.Object3D,
): Record<string, CamPose> {
	const cameras: Record<string, CamPose> = {};
	scene.traverse((child) => {
		if (child instanceof THREE.Mesh) {
			const name = child.name.toLowerCase();
			if (name === "full_mesh") return;
			child.updateWorldMatrix(true, false);
			child.geometry.computeBoundingBox();
			const box = child.geometry.boundingBox;
			if (!box) return;
			// Get center in world space using the mesh's world matrix
			const center = new THREE.Vector3();
			box.getCenter(center);
			center.applyMatrix4(child.matrixWorld);

			const min = box.min.clone().applyMatrix4(child.matrixWorld);
			const max = box.max.clone().applyMatrix4(child.matrixWorld);
			console.log(
				`[lidar] "${name}" bbox: min [${min.x.toFixed(2)}, ${min.y.toFixed(2)}, ${min.z.toFixed(2)}] max [${max.x.toFixed(2)}, ${max.y.toFixed(2)}, ${max.z.toFixed(2)}] center [${center.x.toFixed(2)}, ${center.y.toFixed(2)}, ${center.z.toFixed(2)}]`,
			);

			// Apply manual override if available
			if (CENTER_OVERRIDES[name]) {
				const [ox, oy, oz] = CENTER_OVERRIDES[name];
				center.set(ox, oy, oz);
				console.log(`[lidar] "${name}" using manual override: [${ox}, ${oy}, ${oz}]`);
			}

			// Offset camera angle and lookAt so product sits in the left ~40% of screen
			const angleOffset = CAMERA_DISTANCE * Math.tan(10 * (Math.PI / 180));
			const screenOffset = 0.2;
			cameras[name] = {
				position: [
					center.x + CAMERA_DISTANCE,
					center.y,
					center.z + angleOffset,
				],
				target: [center.x, center.y, center.z - screenOffset],
				center: [center.x, center.y, center.z],
			};
		}
	});
	return cameras;
}

/** Programmatic camera — smoothly lerps to the target pose */
function CameraController({ cam }: { cam: CamPose }) {
	const { camera } = useThree();
	const targetPos = useRef(new THREE.Vector3(...cam.position));
	const targetLook = useRef(new THREE.Vector3(...cam.target));
	const currentLook = useRef(new THREE.Vector3(...cam.target));

	useEffect(() => {
		targetPos.current.set(...cam.position);
		targetLook.current.set(...cam.target);
	}, [cam]);

	useFrame(() => {
		const speed = 0.04;
		camera.position.lerp(targetPos.current, speed);
		currentLook.current.lerp(targetLook.current, speed);
		camera.lookAt(currentLook.current);
	});

	return null;
}

function ShelfModel({
	activeProduct,
	onCamerasReady,
}: {
	activeProduct: string | null;
	onCamerasReady: (cameras: Record<string, CamPose>) => void;
}) {
	const { scene } = useGLTF("/lidar-mesh.glb");
	const camerasBuilt = useRef(false);

	useEffect(() => {
		if (camerasBuilt.current) return;
		camerasBuilt.current = true;
		const cameras = buildCamerasFromScene(scene);
		console.log("[lidar] Mesh names in GLB:", Object.keys(cameras));
		onCamerasReady(cameras);
	}, [scene, onCamerasReady]);

	const activeMeshes = useRef<THREE.Mesh[]>([]);

	useEffect(() => {
		activeMeshes.current = [];
		scene.traverse((child) => {
			if (child instanceof THREE.Mesh) {
				const name = child.name.toLowerCase();
				const isActive = activeProduct && name === activeProduct;

				if (!child.userData._originalMaterial) {
					child.userData._originalMaterial = child.material;
				}

				if (isActive) {
					child.material = child.material.clone();
					child.material.emissive = new THREE.Color(0x00ff44);
					child.material.emissiveIntensity = 1.9;
					activeMeshes.current.push(child);
				} else if (child.userData._originalMaterial) {
					child.material = child.userData._originalMaterial;
				}
			}
		});
	}, [activeProduct, scene]);

	// Pulse the glow intensity
	useFrame(({ clock }) => {
		const t = clock.getElapsedTime();
		const pulse = 1.35 + Math.sin(t * 3) * 0.5;
		for (const mesh of activeMeshes.current) {
			const mat = mesh.material as THREE.MeshStandardMaterial;
			mat.emissiveIntensity = pulse;
		}
	});

	return <primitive object={scene} />;
}

const DOT_MATERIAL = new THREE.MeshStandardMaterial({
	color: 0x000000,
	emissive: new THREE.Color(0x00ff44),
	emissiveIntensity: 3,
	toneMapped: false,
});

function ProductDots({
	cameras,
	activeProduct,
}: {
	cameras: Record<string, CamPose>;
	activeProduct: string | null;
}) {
	if (activeProduct) return null;

	return (
		<group>
			{Object.entries(cameras).map(([name, cam]) => (
				<mesh
					key={name}
					position={[cam.center[0] + 0.15, cam.center[1], cam.center[2]]}
					material={DOT_MATERIAL}
				>
					<sphereGeometry args={[0.02, 12, 12]} />
				</mesh>
			))}
		</group>
	);
}

function LidarPage() {
	const [activeProduct, setActiveProduct] = useState<string | null>(null);
	const [productInfo, setProductInfo] = useState<LidarProduct | null>(null);
	const [productCameras, setProductCameras] = useState<
		Record<string, CamPose>
	>({});

	useEffect(() => {
		const disconnect = connectLidarSocket((product) => {
			console.log("[lidar] Setting active product:", product.item_desc);
			setActiveProduct(product.item_desc);
			setProductInfo(product);
		});
		return disconnect;
	}, []);

	const cam = activeProduct
		? productCameras[activeProduct] || DEFAULT_CAMERA
		: DEFAULT_CAMERA;

	return (
		<div className="relative h-[100dvh] w-full bg-black">
			<Canvas
				camera={{ position: DEFAULT_CAMERA.position, fov: 50 }}
				style={{ width: "100%", height: "100%" }}
			>
				<Suspense fallback={null}>
					<ambientLight intensity={0.6} />
					<directionalLight position={[5, 5, 5]} intensity={0.8} />
					<ShelfModel
						activeProduct={activeProduct}
						onCamerasReady={setProductCameras}
					/>
					<Environment preset="warehouse" />
					<fog attach="fog" args={["#7a6244", 3, 8]} />
					<color attach="background" args={["#7a6244"]} />
					<ProductDots
						cameras={productCameras}
						activeProduct={activeProduct}
					/>
					<CameraController cam={cam} />
						<EffectComposer>
						<Bloom
							luminanceThreshold={1.0}
							luminanceSmoothing={0.3}
							intensity={0.3}
							mipmapBlur
						/>
						<ToneMapping />
					</EffectComposer>
				</Suspense>
			</Canvas>

			{/* Product info overlay — right side */}
			{productInfo && (
				<div className="absolute inset-y-0 right-0 flex w-[45%] items-center justify-center p-12">
					<div className="w-full max-w-lg border border-black/10 bg-white/70 p-14 text-black shadow-2xl backdrop-blur-sm">
						{productInfo.item_url &&
							productInfo.item_url !== "-" && (
								<div className="mb-8 flex items-center justify-center">
									<img
										src={productInfo.item_url}
										alt={productInfo.item_desc.replace(/_/g, " ")}
										className="h-56 w-56 object-contain"
									/>
								</div>
							)}
						<h2 className="text-4xl font-bold leading-tight">
							{PRODUCT_NAMES[productInfo.item_desc] ||
								productInfo.item_desc.replace(/_/g, " ")}
						</h2>
						<div className="mt-8 space-y-4 text-xl">
							<p>
								<span className="font-medium text-black/50">EPC </span>
								<span className="font-mono text-black/80">{productInfo.epc}</span>
							</p>
							<p>
								<span className="font-medium text-black/50">UPC </span>
								<span className="text-black/80">{productInfo.upc}</span>
							</p>
						</div>
					</div>
				</div>
			)}

			{/* Reset button */}
			{activeProduct && (
				<div className="fixed top-4 left-4 z-50">
					<Button
						type="button"
						variant="outline"
						size="sm"
						className="gap-2 bg-background/80 shadow-sm backdrop-blur-sm"
						onClick={() => {
							setActiveProduct(null);
							setProductInfo(null);
						}}
					>
						Reset view
					</Button>
				</div>
			)}
		</div>
	);
}
