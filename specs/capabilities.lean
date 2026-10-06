/-!
  # Formal Capability Calculus & Zero Ambient Authority Invariant
  Part of Unhackable Computing Stack (UCS)

  Formalizes the mathematical property that in a zero-ambient-authority system,
  a subject cannot invoke an operational transition without presenting an unforgeable
  capability token that confers explicit permission over the target object.
-/

namespace UnhackableStack.CapabilityCalculus

/-- Identifiers for subjects (processes/threads) and objects (memory, endpoints, devices). -/
structure SubjectId where
  id : Nat
  deriving Repr, DecidableEq

structure ObjectId where
  id : Nat
  deriving Repr, DecidableEq

/-- Set of explicit rights that a capability can grant. -/
inductive Right : Type
  | Read
  | Write
  | Execute
  | Grant
  deriving Repr, DecidableEq

/-- An unforgeable capability token combining an object identifier and granted rights. -/
structure Capability where
  target : ObjectId
  rights : List Right
  deriving Repr, DecidableEq

/-- The system state tracks the capability possession map for every subject. -/
structure SystemState where
  capabilities : SubjectId → List Capability

/-- Authorization predicate: A subject is authorized to exercise a right over an object
    if and only if it explicitly holds a capability matching that target and right. -/
def IsAuthorized (state : SystemState) (s : SubjectId) (obj : ObjectId) (r : Right) : Prop :=
  ∃ cap ∈ state.capabilities s, cap.target = obj ∧ r ∈ cap.rights

/-- Theorem: Zero Ambient Authority.
    If a subject holds no capability for object `obj`, it is impossible for it
    to be authorized for any right `r` over `obj`. -/
theorem zero_ambient_authority
    (state : SystemState)
    (s : SubjectId)
    (obj : ObjectId)
    (r : Right)
    (h_no_caps : ∀ cap ∈ state.capabilities s, cap.target ≠ obj) :
    ¬ (IsAuthorized state s obj r) := by
  intro h_auth
  rcases h_auth with ⟨cap, h_in, h_target, _⟩
  have h_neq := h_no_caps cap h_in
  exact h_neq h_target

end UnhackableStack.CapabilityCalculus
