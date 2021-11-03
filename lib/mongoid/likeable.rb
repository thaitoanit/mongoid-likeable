# frozen_string_literal: true

require 'mongoid'

module Mongoid
  module Likeable
    extend ActiveSupport::Concern

    included do
      field :likes, type: Integer, default: 0
      field :likers, type: Array, default: []
      field :dislikes, type: Integer, default: 0
      field :dislikers, type: Array, default: []
      field :votes, type: Integer, default: 0
      field :voters, type: Array, default: []
    end

    # Like
    def like(liker)
      id = liker_id(liker)
      return if liked? id

      push likers: id
      update_likers
    end

    def unlike(liker)
      id = liker_id(liker)
      return unless liked? id

      pull likers: id
      update_likers
    end

    def liked?(liker)
      id = liker_id(liker)
      likers.include?(id)
    end

    # Dislike

    def dislike(disliker)
      id = disliker_id(disliker)
      return if disliked? id

      push dislikers: id
      update_dislikers
    end

    def undislike(disliker)
      id = disliker_id(disliker)
      return unless disliked? id

      pull dislikers: id
      update_dislikers
    end

    def disliked?(disliker)
      id = disliker_id(disliker)
      dislikers.include?(id)
    end

    # Vote

    def vote(voter)
      id = voter_id(voter)
      return if liked? id

      push voters: id
      update_voters
    end

    def unvote(voter)
      id = voter_id(voter)
      return unless liked? id

      pull voters: id
      update_voters
    end

    def voted?(voter)
      id = voter_id(voter)
      voters.include?(id)
    end

    private

    # Like
    def liker_id(liker)
      if liker.respond_to?(:_id)
        liker._id
      else
        liker
      end
    end

    def update_likers
      update_attribute :likes, likers.size
    end

    # Dislike
    def disliker_id(disliker)
      if disliker.respond_to?(:_id)
        disliker._id
      else
        disliker
      end
    end

    def update_dislikers
      update_attribute :dislikes, dislikers.size
    end

    # Vote
    def voter_id(liker)
      if liker.respond_to?(:_id)
        liker._id
      else
        liker
      end
    end

    def update_voters
      update_attribute :votes, voters.size
    end
  end
end
