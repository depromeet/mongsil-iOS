//
//  Reducer+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture

extension Reducer {
  public func onChange<LocalState>(
    of toLocalState: @escaping (State) -> LocalState,
    perform additionalEffects:
      @escaping (LocalState, inout State, Action, Environment) -> Effect<Action, Never>
  ) -> Self where LocalState: Equatable {
    return Reducer<State, Action, Environment> { (state: inout State, action: Action, environment: Environment) in
      let previousLocalState: LocalState = toLocalState(state)
      let effects: Effect<Action, Never> = self.run(&state, action, environment)
      let localState: LocalState = toLocalState(state)

      return previousLocalState != localState
        ? Effect<Action, Never>.merge(effects, additionalEffects(localState, &state, action, environment))
        : effects
    }
  }

  public func onChange<LocalState>(
    of toLocalState: @escaping (State) -> LocalState,
    perform additionalEffects: @escaping (LocalState, LocalState, inout State, Action, Environment)
      -> Effect<Action, Never>
  ) -> Self where LocalState: Equatable {
    return Reducer<State, Action, Environment> { (state: inout State, action: Action, environment: Environment) in
      let previousLocalState: LocalState = toLocalState(state)
      let effects: Effect<Action, Never> = self.run(&state, action, environment)
      let localState: LocalState = toLocalState(state)

      return previousLocalState != localState
        ? Effect<Action, Never>.merge(
          effects, additionalEffects(previousLocalState, localState, &state, action, environment))
        : effects
    }
  }
}
